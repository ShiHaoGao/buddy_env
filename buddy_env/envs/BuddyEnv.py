import gymnasium as gym
import json5
from buddy_env.envs.utils import *
from gymnasium import spaces
import numpy as np
from collections import defaultdict
from typing import Dict


class BuddyEnv(gym.Env):

    def __init__(self, input_file,
                 action_file,
                 dialect_file,
                 compiler,
                 translator,
                 max_pass_length: int = 10):
        self.source_file = input_file
        self.tmp_file = './tmp.mlir'

        # 加载参数集合
        with open(action_file) as f:
            self.params_space = json5.load(f)  # read from file
        self.params_size = len(self.params_space)

        # 加载方言集合
        with open(dialect_file) as f:
            dialects = json5.load(f)
        self.dialect_size = len(dialects)
        self.dialects_space = {}

        # 构建dialect : index 的映射关系。
        for k, v in zip(dialects, range(self.dialect_size)):
            self.dialects_space[k] = v

        # 记录上一次的obs，用于与新的obs比较，计算reward
        self.old_obs = None

        # 初始化action_space
        self.action_space = spaces.Discrete(self.params_size)

        # 这里后期我们可以用一个网络，这个网络训练我们究竟应该从mlir文本中取得什么样的observation才比较好。
        # 现在，我们仅仅就选择用所有dialect和其对应的op，作为observation。
        self.observation_space = spaces.Box(low=0, high=np.inf, shape=(self.dialect_size,), dtype=np.int8)

        self.compiler = compiler
        self.translator = translator
        self.episode_passes_list = None
        self.episode_passes_str = None
        self.episode_reward = None
        self.max_pass_length = max_pass_length

    def _action_to_str(self, action) -> str:
        return self.params_space[action]

    def _dialect_str_to_index(self, dialect_name) -> int:
        return self.dialects_space[dialect_name]

    def _get_obs_and_info(self, flag: str = '') -> (np.ndarray, Dict):
        info = get_features(self.compiler, self.source_file, self.tmp_file, flag)
        mlir_state = info['state']

        obs = np.zeros((self.dialect_size,), dtype=np.int8)

        # build new obs
        if mlir_state is True:
            for dialect, Ops in info['features'].items():
                op_count = 0
                for _, v, in Ops.items():
                    op_count = int(v) + op_count
                obs[self._dialect_str_to_index(dialect)] = op_count

        return obs, info

    def _test(self) -> bool:
        print("test!!!")
        try:
            command = self.translator + ' ' + self.tmp_file + ' --mlir-to-llvmir -o tmp.ll'
            subprocess.run(command, shell=True, check=True)
            return True
        except subprocess.CalledProcessError as cpe:
            print('translate mlir file error!')
            return False

    def step(self, action):

        """

        :param action: pass index
        :return:

        Note:
            在step中维护episode_passes_list和episode_reward。
            更新old_obs。
            如果action与episode之前的重复，那么reward -= 10
        """

        rew = 0
        terminated = False  # 看看terminated和 truncated的具体定义，别用错了
        truncated = False

        param = self._action_to_str(action)

        # 通过给punish，防止agent重复作用param
        if param in self.episode_passes_list:
            rew -= 5

        self.episode_passes_list.append(action)
        self.episode_passes_str += param + ' '

        observation, info = self._get_obs_and_info(flag=self.episode_passes_str)

        if info['state'] is False:
            truncated = True
            rew -= 30  # 这个数是拍脑门想的
        else:
            print("cool!!!")
            rew += self._compute_reward(observation)
            termi = {'llvm', 'builtin'}
            print(info)
            if set(info['features'].keys()) == termi and len(info['features']['builtin'].keys()) == 1:
                terminated = True
                rew += 50
                if self._test():
                    truncated = False
                    rew += 100
                else:
                    truncated = True
                    rew -= 100

        self.episode_reward += rew
        self.old_obs = observation

        if len(env.episode_passes_list) >= env.max_pass_length:
            env.close()
            env.reset()

        return observation, rew, terminated, truncated, info

    def render(self):
        """
        This function prints information about the passes.
        """

        print("pass: {}".format(self.episode_passes_list))
        print("reward: {}".format(self.episode_reward))

    # TODO: 计算reward的方式是靠近llvm dialect，还可以把op也加进来，llvm的op越多，reward越高。
    # 辅助以这种减少dialect数的reward作用。
    # 可以让出现llvm op的reward变多，减少dialect的reward变少
    # 后期加入时间度量后，再更新reward。
    def _compute_reward(self, obs: np.ndarray) -> int:
        rew = 0  # 如果没有任何变化的话，就是-1

        # 比较old_obs与new_obs的区别，找出区别
        tmp = self.old_obs == obs

        flag = True
        # 如果dialect对应的op数量有变化，就reward+1
        for equal_flag in tmp:
            if not equal_flag:
                flag = False
                rew += 1

        # flag is true 说明没有任何变化
        if flag:
            rew -= 10

        # 如果llvm 的op数量有变化，reward额外+1
        if not tmp[17]:  # 17 是llvm 的index
            rew += 1
        # for index, less_flag in enumerate(np.less(tmp, self.old_obs)):
        #     if less_flag:
        #
        #
        # for dialect in same_dialect:
        #     differ = set(self.old_info[dialect].items()) ^ set(info[dialect].items())
        #     if differ is not None:
        #         rew += 1  # 在dialect内部有变化，reward+
        #     if dialect == 'llvm':
        #         rew += 1  # 鼓励对llvm中op的增加
        #
        # for dialect in only_new_dialect:
        #     rew += 1  # 出现了新的dialect
        #     if dialect == 'llvm':  # 尽快出现llvm dialect
        #         rew += 1
        #
        # for dialect in only_old_dialect:
        #     rew += 1  # 消除了一些dialect

        print('compute reward:' + str(rew))
        return rew

    # 创建临时mlir文件，并获得当前的observation
    def reset(self, seed=None, options=None) -> (np.ndarray, Dict):
        # self.source_file = copy_file(self._input_file, tmp_file_name='tmp.mlir')
        self.old_obs, info = self._get_obs_and_info(flag='')
        self.episode_passes_list = []
        self.episode_passes_str = ""
        self.episode_reward = 0
        return self.old_obs, info

    # 删除tmp.mlir文件。
    def close(self):
        print('episode sum is ' + str(self.episode_reward))
        print("episode pass: {}".format(self.episode_passes_list))
        self.episode_passes_list = None
        self.episode_reward = None

        try:
            command = 'rm -f ' + self.tmp_file
            subprocess.run(command, shell=True, check=True)
        except subprocess.CalledProcessError as cpe:
            print("close file error!")
            raise


if __name__ == '__main__':
    source_file = '../res/linalg-conv2d.mlir'
    # param_file = '../res/params_space.json'
    param_file = '../res/label.json'
    dialect_file = '../res/dialects_space.json'
    compiler = '../tools/mlir-opt'
    translator = '../tools/mlir-translate'
    env = BuddyEnv(source_file, param_file, dialect_file, compiler, translator)
    obs, info = env.reset()

    pre_pass = iter([0, 1, 2, 3, 4, 5, 6, 7])

    # train
    for i in range(100):
        action = env.action_space.sample()
        # print(action)
        obs, reward, terminated, truncated, done = env.step(next(pre_pass))
        print('reward:', reward)
        if terminated:
            print("yes")

        if truncated:
            print("no")
            print("episode reward: " + str(env.episode_reward))
            env.close()
            env.reset()
            continue

        # if len(env.episode_passes_list) >= env.max_pass_length:
        #     env.close()
        #     env.reset()

    env.close()

import gymnasium as gym
import json5
from gymnasium.core import ObsType

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
                 max_passes_length: int = 10,
                 verbose: bool = False):
        super(BuddyEnv, self).__init__()
        self.source_file = input_file
        self.tmp_file = './tmp.mlir'
        self.compiler = compiler
        self.translator = translator
        self.episode_passes_list = None
        self.episode_passes_str = None
        self.episode_reward = 0
        self.max_passes_length = max_passes_length
        self.best_episode_passes_list = None
        self.best_episode_reward = 0
        self.old_obs = None  # 记录上一次的obs，用于与新的obs比较，计算reward
        self.verbose = verbose

        # 加载参数集合
        with open(action_file) as f:
            self.params_space = json5.load(f)  # read from file
        self.params_size = len(self.params_space)

        # 加载方言集合
        with open(dialect_file) as f:
            dialects = json5.load(f)
        self.dialect_size = len(dialects)
        self.dialects_space = {}

        self.obs_dim = self.dialect_size + self.max_passes_length

        # 构建dialect : index 的映射关系。
        for k, v in zip(dialects, range(self.dialect_size)):
            self.dialects_space[k] = v

        # 初始化action_space
        self.action_space = spaces.Discrete(self.params_size)

        # 这里后期我们可以用一个网络，这个网络训练我们究竟应该从mlir文本中取得什么样的observation才比较好。
        # 现在，我们仅仅就选择用所有dialect和其对应的op，作为observation。
        self.observation_space = spaces.Box(low=0, high=np.inf, shape=(self.obs_dim,), dtype=np.int8)

    def _action_to_str(self, act) -> str:
        return self.params_space[act]

    def _dialect_str_to_index(self, dialect_name) -> int:
        return self.dialects_space[dialect_name]

    def _get_obs_and_info(self, flag: str = '') -> (np.ndarray, Dict):
        info = get_features(self.compiler, self.source_file, self.tmp_file, flag)
        mlir_state = info['state']

        # 构造observation
        obs = np.zeros((self.obs_dim,), dtype=np.int8)

        if mlir_state is True:
            for dialect, op_count in info['features'].items():
                obs[self._dialect_str_to_index(dialect)] = op_count

        # for idx in range(len(self.episode_passes_list)):
        #     obs[self.dialect_size + idx] = self.episode_passes_list[idx]
        if self.episode_passes_list is not None and len(self.episode_passes_list) != 0:
            idx = len(self.episode_passes_list) - 1
            obs[self.dialect_size + idx] = self.episode_passes_list[idx]

        return obs, info

    def _test(self) -> bool:
        # print("test!!!")
        try:
            command = self.translator + ' ' + self.tmp_file + ' --mlir-to-llvmir -o tmp.ll'
            subprocess.run(command, shell=True, check=True)
            return True
        except subprocess.CalledProcessError as cpe:
            print('translate mlir file error!')
            return False

    def step(self, act):

        """

        :param act: pass index
        :return:

        Note:
            在step中维护episode_passes_list和episode_reward。
            更新old_obs。
            如果action与episode之前的重复，那么reward -= 10
        """

        next_pure_obs = np.zeros((self.obs_dim,), dtype=np.int8)

        rew = 0

        # 在action执行之前-----------------
        # 不进行render
        # truncated state : 通过 reward = -10 ，不结束episode，阻止agent重复作用相同的param
        if self.is_pass_repeated_in_episode(act):
            # print("repeat!")
            rew -= 10
            # self.episode_reset()
            # return next_pure_obs, -10, False, True, \
            #     {'features': None, 'state': False, 'message': 'current pass repeats!'}

        # 全新的pass
        param = self._action_to_str(act)
        self.episode_passes_list.append(act)
        self.episode_passes_str += param + ' '

        # action执行-------------
        next_observation, info = self._get_obs_and_info(flag=self.episode_passes_str)

        # action执行以后------------

        # terminated: reward = -10
        if self.is_compile_with_pass_failed(info):
            self.episode_reward -= 10
            self.render()
            self.episode_reset()
            info['features'] = None
            info['state'] = False
            info['message'] = 'failed! Compiler with pass:{}'.format(param)
            return next_pure_obs, -10, True, False, info

        rew += self._compute_reward(next_observation)

        # terminated state
        if self.is_final_dialects(info):
            rew += 20
            if self._test():
                rew += 50
            else:
                rew -= 50
            self.episode_reward += rew
            self.render()
            self.episode_reset()
            info['features'] = None
            return next_observation, rew, True, False, info

        info['features'] = None
        self.episode_reward += rew
        self.old_obs = next_observation
        self.render()

        # truncated state
        if self.is_episode_passes_length_ge_max_passes_length():
            self.episode_reset()
            info['features'] = None
            info['state'] = False
            info['message'] = 'The length of passes is greater than max_pass_length'
            return next_observation, rew, False, True, info

        # 还在一个episode中，继续下一个step
        # return observation, rew, False, False, info
        return next_observation, rew, False, False, info

    def is_final_dialects(self, info) -> bool:
        terminal_dialects = {'llvm', 'builtin'}
        return set(info['features'].keys()) == terminal_dialects and info['features']['builtin'] == 1

    # truncated state1
    def is_pass_repeated_in_episode(self, param: str) -> bool:
        return param in self.episode_passes_list

    # truncated state2
    def is_episode_passes_length_ge_max_passes_length(self):
        return len(self.episode_passes_list) >= self.max_passes_length

    # terminated state1
    def is_compile_with_pass_failed(self, info):
        return info['state'] is False

    def episode_reset(self):
        self.close()
        self.reset()

    # 在每一个action真正执行后，执行render
    def render(self):
        """
        This function prints information about the passes.
        """
        if self.verbose:
            print("pass: {}".format(self.episode_passes_list))
            print("cumulated reward: {}".format(self.episode_reward))

    # 计算reward的方式是靠近llvm dialect，还可以把op也加进来，llvm的op越多，reward越高。
    # 辅助以这种减少dialect数的reward作用。
    # 可以让出现llvm op的reward变多，减少dialect的reward变少
    # 后期加入时间度量后，再更新reward。
    def _compute_reward(self, obs: np.ndarray) -> int:
        rew = 0  # 如果没有任何变化的话，就是-1

        # 比较old_obs与new_obs的区别，找出区别
        tmp = self.old_obs[:self.dialect_size] == obs[:self.dialect_size]
        # print(len(tmp))
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

        # print('compute reward:' + str(rew))
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
        print('episode done!')
        print('episode sum is ' + str(self.episode_reward))
        print("episode pass: {}".format(self.episode_passes_list))
        if self.episode_reward > self.best_episode_reward:
            self.best_episode_reward = self.episode_reward
            self.best_episode_passes_list = self.episode_passes_list

        self.episode_passes_list = None
        self.episode_reward = None
        self.episode_passes_str = None

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
    env = BuddyEnv(source_file, param_file, dialect_file, compiler, translator, max_passes_length=10, verbose=False)
    obs, info = env.reset()

    pre_pass = iter([0, 1, 2, 3, 4, 5, 6, 7])

    # train
    for i in range(10000):
        action = env.action_space.sample()
        # print(action)
        obs, reward, terminated, truncated, done = env.step(action)
        # print('reward:', reward)

        # if truncated or terminated:
        #      print('episode done!')
        #      print("episode reward: " + str(env.episode_reward))
        #      continue

        # if len(env.episode_passes_list) >= env.max_pass_length:
        #     env.close()
        #     env.reset()

    env.close()
    print("best reward:" + str(env.best_episode_reward))
    print("best passes list:" + str(env.best_episode_passes_list))

import gymnasium as gym
import json5
from buddy_env.envs.utils import *
from gymnasium.spaces import Discrete, MultiBinary
import numpy as np
from typing import Dict
from collections import defaultdict


class BuddyEnv(gym.Env):

    def __init__(self, input_file: str = '',
                 action_file: str = '',
                 dialect_file: str = '',
                 compiler: str = '',
                 translator: str = ''):
        self.source_file = None
        self._input_file = input_file

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

        # 记录上一次的info，用于与新的info比较，计算reward
        self.old_info = None

        # 初始化action_space
        self.action_space = Discrete(self.params_size)

        # 这里后期我们可以用一个网络，这个网络训练我们究竟应该从mlir文本中取得什么样的observation才比较好。
        # 现在，我们仅仅就选择用所有dialect的空间来作为observation。
        self.observation_space = MultiBinary(self.dialect_size)

        self.compiler = compiler
        self.translator = translator
        self.passes = []
        self.rewards = []
        self.max_passes_length = 10

    def _action_to_str(self, action) -> str:
        return self.params_space[action]

    def _get_obs_and_info(self, param: str = '') -> (MultiBinary, Dict):
        try:
            info = get_dialects(self.compiler, self.source_file, param)
            mask = np.zeros(self.dialect_size, dtype=np.int8)
            for k in info.keys():
                mask[self.dialects_space[k]] = 1
            obs = self.observation_space.sample(mask=mask)
            return obs, info
        except subprocess.CalledProcessError as cpe:
            print('_get_obs_and_info CalledProcessError')
            raise

    def _test(self) -> bool:
        print("test!!!")
        try:
            command = self.translator + ' ' + '--mlir-to-llvmir -o tmp.ll'
            subprocess.run(command, shell=True, check=True)
            return True
        except subprocess.CalledProcessError as cpe:
            print('copy mlir file error!')
            return False

    def step(self, action):
        param = self._action_to_str(action)

        # info = _get_info()
        observation = None
        info = None
        reward = 0
        terminated = False
        truncated = False
        try:
            observation, info = self._get_obs_and_info(param)
            # 这里发现一个问题：我不需要observation
            reward += self._compute_reward(info)
            termi = {'llvm', 'builtin'}
            if set(info.keys()) == termi:
                terminated = True
                reward += 50
                if self._test():
                    truncated = False
                    reward += 100
                else:
                    truncated = True
                    reward -= 100
        except subprocess.CalledProcessError as cpe:
            truncated = True
            reward -= 30  # 这个数是拍脑门想的

        self.rewards.append(reward)
        self.passes.append(param)

        return observation, reward, terminated, truncated, info

    def render(self):
        """
        This function prints information about the passes.
        """

        print("pass: {}".format(self.passes))

    # TODO: 计算reward的方式是靠近llvm dialect，还可以把op也加进来，llvm的op越多，reward越高。
    # 辅助以这种减少dialect数的reward作用。
    # 可以让出现llvm op的reward变多，减少dialect的reward变少
    # 后期加入时间度量后，再更新reward。
    def _compute_reward(self, info: Dict) -> int:
        rew = -1  # 如果没有任何变化的话，就是-1

        # 比较old_info与new_info的区别，找出区别
        old_dialect = self.old_info.keys()
        new_dialect = info.keys()
        same_dialect = old_dialect & new_dialect
        only_new_dialect = new_dialect - old_dialect
        only_old_dialect = old_dialect - new_dialect

        for dialect in same_dialect:
            differ = set(self.old_info[dialect].items()) ^ set(info[dialect].items())
            if differ is not None:
                rew += 1  # 在dialect内部有变化，reward+5
            if dialect == 'llvm':
                rew += 1  # 鼓励对llvm中op的增加

        for dialect in only_new_dialect:
            rew += 1
            if dialect == 'llvm':  # 尽快出现llvm dialect
                rew += 1

        for dialect in only_old_dialect:
            rew += 1

        self.old_info = info
        return rew

    # 创建临时mlir文件，并获得当前的observation
    def reset(self, seed=None, options=None) -> (MultiBinary, Dict):
        self.source_file = copy_file(self._input_file, 'tmp.mlir')
        obs, self.old_info = self._get_obs_and_info('')
        self.passes = []
        self.rewards = []
        return obs, self.old_info

    # 删除tmp.mlir文件。
    def close(self):
        try:
            command = 'rm -f ' + self.source_file
            subprocess.run(command, shell=True, check=True)
        except subprocess.CalledProcessError as cpe:
            print("close file error!")
            raise


if __name__ == '__main__':
    source_file = '../res/linalg-conv2d.mlir'
    # param_file = '../res/params_space.json'
    param_file = '../res/label.json'
    dialect_file = '../res/dialects_space.json'
    env = BuddyEnv(source_file, param_file, dialect_file)
    obs, info = env.reset()

    # train
    for i in range(100):
        action = env.action_space.sample()
        # print(action)
        obs, reward, terminated, truncated, done = env.step(action)

        if terminated:
            print("yes")

        if truncated:
            print("failed")
            env.close()
            env.reset()
            continue

    env.close()

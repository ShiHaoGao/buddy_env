import gymnasium as gym
from gymnasium import Wrapper


class SaveEpisodeAction(Wrapper):

    def __init__(self, env):
        super().__init__(env)
        self.action_list = []

    def step(self, action):
        self.action_list.append()
        obs, reward, terminated, truncated, info = self.env.step(action)
        pass

    def reset(self):
        pass

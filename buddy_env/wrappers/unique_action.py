import gymnasium as gym
from gymnasium import ActionWrapper, ObservationWrapper, RewardWrapper, Wrapper


class UniqueAction(Wrapper):

    def __init__(self, env):
        super().__init__(env)

    def step(self, action):

        # 在这里判断action是否唯一
        # 如果不唯一，

        obs, _, terminated, truncated, info = self.env.step(action)
        reward = (
                self.reward_dist_weight * info["reward_dist"]
                + self.reward_ctrl_weight * info["reward_ctrl"]
        )
        return obs, reward, terminated, truncated, info

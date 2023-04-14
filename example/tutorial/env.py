from tianshou.env import DummyVectorEnv
import gymnasium as gym

# In Gym
env = gym.make("CartPole-v0")


# In Tianshou
def helper_function():
    env = gym.make("CartPole-v0")
    # other operations such as env.seed(np.random.choice(10))
    return env


envs = DummyVectorEnv([helper_function for _ in range(5)])
print(envs)

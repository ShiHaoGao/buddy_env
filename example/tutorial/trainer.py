import gymnasium as gym
import numpy as np
import torch

from tianshou.data import Collector, VectorReplayBuffer
from tianshou.env import DummyVectorEnv
from tianshou.policy import PGPolicy
from tianshou.utils.net.common import Net
from tianshou.utils.net.discrete import Actor

import warnings

warnings.filterwarnings('ignore')

train_env_num = 4
buffer_size = 2000  # Since REINFORCE is an on-policy algorithm, we don't need a very large buffer size

# Create the environments, used for training and evaluation
env = gym.make("CartPole-v1")
test_envs = DummyVectorEnv([lambda: gym.make("CartPole-v1") for _ in range(2)])
train_envs = DummyVectorEnv([lambda: gym.make("CartPole-v1") for _ in range(train_env_num)])

# Create the Policy instance
net = Net(env.observation_space.shape, hidden_sizes=[16, ])
actor = Actor(net, env.action_space.shape)
optim = torch.optim.Adam(actor.parameters(), lr=0.001)
policy = PGPolicy(actor, optim, dist_fn=torch.distributions.Categorical)

# Create the replay buffer and the collector
replaybuffer = VectorReplayBuffer(buffer_size, train_env_num)
test_collector = Collector(policy, test_envs)  # 可以发现，test_collector没有replaybuffer，因为不做训练，只是测试
train_collector = Collector(policy, train_envs, replaybuffer)

train_collector.reset()
train_envs.reset()
test_collector.reset()
test_envs.reset()
replaybuffer.reset()
for i in range(10):  # 10 epoch
    evaluation_result = test_collector.collect(n_episode=10)  # test_collector用来测试当前policy，得出reward。
    print("Evaluation reward is {}".format(evaluation_result["rew"]))
    train_collector.collect(n_step=2000)  # 收集2000个step到replaybuffer中
    # 0 means taking all data stored in train_collector.buffer
    policy.update(0, train_collector.buffer, batch_size=512, repeat=1)  # buffer中所有数据，每次batch_size为512，
    train_collector.reset_buffer(keep_statistics=True)

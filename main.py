import argparse

import buddy_env
import gymnasium as gym
import numpy as np
import torch

from tianshou.data import Collector, VectorReplayBuffer, ReplayBuffer
from tianshou.env import DummyVectorEnv
from tianshou.policy import PPOPolicy
from tianshou.trainer import onpolicy_trainer
from tianshou.utils.net.common import ActorCritic, Net
from tianshou.utils.net.discrete import Actor, Critic

import warnings


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", type=str, default="LunarLander-v2")
    parser.add_argument("--source_file", type=str, default="./buddy_env/res/linalg-conv2d.mlir")
    parser.add_argument("--param_file", type=str, default="./buddy_env/res/label.json")
    # ./buddy_env/res/params_space.json
    parser.add_argument("--dialect_file", type=str, default="./buddy_env/res/dialects_space.json")
    parser.add_argument("--compiler", type=str, default="./buddy_env/tools/mlir-opt")
    parser.add_argument("--translator", type=str, default="./buddy_env/tools/mlir-translate")
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--scale-obs", type=int, default=0)
    parser.add_argument("--eps-test", type=float, default=0.005)
    parser.add_argument("--eps-train", type=float, default=1.)
    parser.add_argument("--eps-train-final", type=float, default=0.05)
    parser.add_argument("--buffer-size", type=int, default=100000)
    parser.add_argument("--lr", type=float, default=0.0000625, help="Learning rate.")
    parser.add_argument("--gamma", type=float, default=0.99)
    parser.add_argument("--num-atoms", type=int, default=51)
    parser.add_argument("--v-min", type=float, default=-10.)
    parser.add_argument("--v-max", type=float, default=10.)
    parser.add_argument("--noisy-std", type=float, default=0.1)
    parser.add_argument("--no-dueling", action="store_true", default=False)
    parser.add_argument("--no-noisy", action="store_true", default=False)
    parser.add_argument("--no-priority", action="store_true", default=False)
    parser.add_argument("--alpha", type=float, default=0.5)
    parser.add_argument("--beta", type=float, default=0.4)
    parser.add_argument("--beta-final", type=float, default=1.)
    parser.add_argument("--beta-anneal-step", type=int, default=5000000)
    parser.add_argument("--no-weight-norm", action="store_true", default=False)
    parser.add_argument("--n-step", type=int, default=3)
    parser.add_argument("--target-update-freq", type=int, default=500)
    parser.add_argument("--epoch", type=int, default=100)
    parser.add_argument("--step-per-epoch", type=int, default=100000)
    parser.add_argument("--step-per-collect", type=int, default=10)
    parser.add_argument("--update-per-step", type=float, default=0.1)
    parser.add_argument("--batch-size", type=int, default=32)
    parser.add_argument("--training-num", type=int, default=10)
    parser.add_argument("--test-num", type=int, default=10)
    parser.add_argument("--logdir", type=str, default="log")
    parser.add_argument("--render", type=float, default=0.)
    parser.add_argument(
        "--device", type=str, default="cuda" if torch.cuda.is_available() else "cpu"
    )
    parser.add_argument("--frames-stack", type=int, default=4)
    parser.add_argument("--resume-path", type=str, default=None)
    parser.add_argument("--resume-id", type=str, default=None)
    parser.add_argument(
        "--logger",
        type=str,
        default="tensorboard",
        choices=["tensorboard", "wandb"],
    )
    parser.add_argument("--wandb-project", type=str, default="atari.benchmark")
    parser.add_argument(
        "--watch",
        default=False,
        action="store_true",
        help="watch the play of pre-trained policy only"
    )
    parser.add_argument("--save-buffer-name", type=str, default=None)
    return parser.parse_args()


def test_ppo(args=get_args()):
    warnings.filterwarnings('ignore')

    device = 'cuda' if torch.cuda.is_available() else 'cpu'

    env = gym.make('buddy_env/BuddyEnv-v0', input_file=args.source_file, action_file=args.param_file,
                   dialect_file=args.dialect_file, compiler=args.compiler, translator=args.translator,
                   max_passes_length=10, verbose=False)
    test_env = gym.make('buddy_env/BuddyEnv-v0', input_file="./buddy_env/res/linalg-generic.mlir", action_file=args.param_file,
                   dialect_file=args.dialect_file, compiler=args.compiler, translator=args.translator,
                   max_passes_length=10, verbose=False)
    print(env.observation_space.shape)
    print(env.action_space)

    # model & optimizer
    net = Net(env.observation_space.shape, hidden_sizes=[128, 128], device=device)
    actor = Actor(net, env.action_space.n, device=device).to(device)
    critic = Critic(net, device=device).to(device)
    actor_critic = ActorCritic(actor, critic)
    optim = torch.optim.Adam(actor_critic.parameters(), lr=0.0003)

    # PPO policy
    dist = torch.distributions.Categorical
    policy = PPOPolicy(actor, critic, optim, dist, action_space=env.action_space, deterministic_eval=True)

    # collector
    train_collector = Collector(policy, env, ReplayBuffer(20000))
    test_collector = Collector(policy, test_env)
    print("1")

    obs, info = env.reset()

    # trainer
    result = onpolicy_trainer(
        policy,
        train_collector,
        test_collector,
        max_epoch=10,
        step_per_epoch=10000,
        repeat_per_collect=10,
        episode_per_test=10,
        batch_size=256,
        step_per_collect=2000,
        stop_fn=lambda mean_reward: mean_reward >= 60,
    )
    print(result)

    # train_collector.reset()
    # obs, info = env.reset()
    #
    # # train
    # for i in range(100):
    #     env.render()
    #     action = env.action_space.sample()
    #     # print(action)
    #
    #     obs, reward, terminated, truncated, done = env.step(action)
    #
    #     if terminated:
    #         print("yes")
    #
    #     if truncated:
    #         print("failed")
    #         break
    #         env.close()
    #         env.reset()
    #         continue
    #
    # env.close()


if __name__ == '__main__':
    test_ppo(get_args())

# environments
# env = gym.make('CartPole-v1', render_mode="human")
# train_envs = DummyVectorEnv([lambda: gym.make('CartPole-v1') for _ in range(20)])
# test_envs = DummyVectorEnv([lambda: gym.make('CartPole-v1') for _ in range(10)])



# # Let's watch its performance!
# policy.eval()
# result = test_collector.collect(n_episode=1, render=False)
# print("Final reward: {}, length: {}".format(result["rews"].mean(), result["lens"].mean()))

# Epoch 1 step = 2000  rew=-81.92
#         step = 4000 rew = -78.02
#         step = 6000 rew = -74.11
#         step = 8000 rew = -69.13
#         step = 10000 rew = -67.98
#         step = 12000 rew = -69.96



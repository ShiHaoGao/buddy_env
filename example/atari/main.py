import gymnasium as gym
import argparse
import tianshou as ts
from model import Rainbow, DQN
import numpy as np
import torch


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--task", type=str, default="LunarLander-v2")
    parser.add_argument("--render_mode", type=str, default="human")
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


def test_rainbow(args=get_args()):
    env = gym.make(args.task, render_mode=args.render_mode)
    state_shape = env.observation_space.shape or env.observation_space.n
    action_shape = env.action_space.shape or env.action_space.n
    print("Observations shape:", state_shape)
    print("Actions shape:", action_shape)

    # Build the Network
    net = DQN(state_shape, action_shape)
    optim = torch.optim.Adam(net.parameters(), lr=1e-3)

    # seed
    np.random.seed(args.seed)
    torch.manual_seed(args.seed)


if __name__ == "__main__":
    test_rainbow()

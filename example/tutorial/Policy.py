from typing import Any, Dict, List, Optional, Type, Union

import numpy as np
import torch

from tianshou.data import Batch, ReplayBuffer, to_torch, to_torch_as
from tianshou.policy import BasePolicy


class REINFORCEPolicy(BasePolicy):
    """Implementation of REINFORCE algorithm."""
    def __init__(self, model: torch.nn.Module, optim: torch.optim.Optimizer,):
        super().__init__()
        self.actor = model
        self.optim = optim

    def forward(self, batch: Batch) -> Batch:
        """Compute action over the given batch data."""
        act = None
        return Batch(act=act)

    def process_fn(self, batch: Batch, buffer: ReplayBuffer, indices: np.ndarray) -> Batch:
        """Compute the discounted returns for each transition."""
        pass

    def learn(self, batch: Batch, batch_size: int, repeat: int) -> Dict[str, List[float]]:
        """Perform the back-propagation."""
        return
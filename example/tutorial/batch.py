import numpy as np
from tianshou.data import Batch


# data = Batch(a=4, b=[5, 5], c='2312312', d=('a', -2, -3))
# print(data)
# print(data.b)

import torch
batch1 = Batch(a=np.arange(2), b=torch.zeros((2,2)))
batch2 = Batch(a=np.arange(2), b=torch.ones((2,2)))
batch_cat = Batch.cat([batch1, batch2, batch1])
# print(batch1)
# print(batch2)
# print(batch_cat)

batch_cat.to_numpy()
print(batch_cat)
batch_cat.to_torch()
print(batch_cat)
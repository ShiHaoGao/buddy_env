from tianshou.data import ReplayBuffer
from tianshou.data import Batch

from numpy import False_

buf = ReplayBuffer(size=10)
# Add the first trajectory (length is 3) into ReplayBuffer
print("========================================")
for i in range(3):
    result = buf.add(Batch(obs=i, act=i, rew=i, terminated=True if i == 2 else False, truncated=False, obs_next=i + 1, info={}))
    print(result)
print(buf)
print("maxsize: {}, data length: {}".format(buf.maxsize, len(buf)))
# Add the second trajectory (length is 5) into ReplayBuffer
print("========================================")
for i in range(3, 8):
    result = buf.add(Batch(obs=i, act=i, rew=i, terminated=True if i == 7 else False, truncated=False, obs_next=i + 1, info={}))
    print(result)
print(buf)
print("maxsize: {}, data length: {}".format(buf.maxsize, len(buf)))

# Search for the previous index of index "6"
now_index = 6
while True:
    prev_index = buf.prev(now_index)
    print(prev_index)
    if prev_index == now_index:
        break
    else:
        now_index = prev_index

# Add the third trajectory (length is 5, still not finished) into ReplayBuffer
# print("========================================")
# for i in range(8, 13):
#     result = buf.add(Batch(obs=i, act=i, rew=i, terminated=False, truncated=i, obs_next=i + 1, info={}))
#     print(result)
# print(buf)
# print("maxsize: {}, data length: {}".format(buf.maxsize, len(buf)))

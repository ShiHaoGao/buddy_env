from gymnasium.envs.registration import register
import logging

logger = logging.getLogger(__name__)

register(
    id="buddy_env/BuddyEnv-v0",
    entry_point="buddy_env.envs:BuddyEnv",
)

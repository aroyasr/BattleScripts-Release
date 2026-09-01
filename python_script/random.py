########################
## random.py ##
########################

from script import Script, ACTIONS
import random

class Random(Script):
    # Initalize the script.
    def __init__(self):
        super().__init__() # This calls the script parent function.

    def steal_or_support(self):
        return random.choice(list(ACTIONS))

script = Random()
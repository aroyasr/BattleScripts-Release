########################
## kind.py ##
########################

from script import Script, ACTIONS

class Kind(Script):
    # Initalize the script.
    def __init__(self):
        super().__init__() # This calls the script parent function.

    def steal_or_support(self):
        return ACTIONS.SUPPORT

script = Kind()
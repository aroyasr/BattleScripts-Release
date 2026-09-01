########################
## custom_variables.py ##
########################

from script import Script, ACTIONS

class CustomVariables(Script):
    # Initalize the script.
    def __init__(self):
        super().__init__() # This calls the script parent function.

        # Define custom variables here.
        self.counter = 0

    def steal_or_support(self):
        self.counter += 1

        if self.counter >= 25:
            return ACTIONS.SUPPORT
        else:
            return ACTIONS.STEAL

script = CustomVariables()
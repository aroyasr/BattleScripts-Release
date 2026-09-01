########################
## array.py ##
########################

from script import Script, ACTIONS

''' Here are some examples of how the array may look

Assuming that you are player 1, and you are kind. The opponent is player 2, and they are selfish

On the 5th turn:
                last_turn = 4     
                my_move_history = [1, 1, 1, 1]     
                their_move_history = [0, 0, 0, 0]     

On the first turn:
                last_turn = 0     
                my_move_history = []     
                their_move_history = []     

On the second turn: 
                last_turn = 1     
                my_move_history = [1]     
                their_move_history = [0]     
'''

# This file focuses on understanding how these arrays work.
'''
self.my_move_history = []        #Array containing your previous moves
self.their_move_history = []     #Array containing the other script's previous moves
'''

class Array(Script):
    # Initalize the script.
    def __init__(self):
        super().__init__() # This calls the script parent function.

        # Define custom variables here.
        self.counter = 0

    def steal_or_support(self):
        return self.arrays_failure()
        #return self.arrays_1()
        #return self.arrays_2()
    
    def arrays_1(self):
        if len(self.their_move_history) == 0:
            return ACTIONS.SUPPORT

        if self.their_move_history[0] == ACTIONS.SUPPORT:
            return ACTIONS.SUPPORT
        else:
            return ACTIONS.STEAL

    def arrays_2(self):
        if len(self.their_move_history) == 0:
            return ACTIONS.SUPPORT

    def arrays_failure(self):
        if len(self.their_move_history) > 0:
            return ACTIONS.STEAL if self.their_move_history[-1] == ACTIONS.STEAL.value else ACTIONS.SUPPORT

        return ACTIONS.STEAL

script = Array()
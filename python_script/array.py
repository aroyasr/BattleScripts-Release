########################
##       array.py     ##
########################

# This default script is a basic script that demonstrates how to properly access
# Values in the provided arrays. 


# Constants 
STEAL = 0
SUPPORT = 1

# Variables 
my_money = 0          #How much money your script currently has in the match
their_money = 0       #How much money the other script currently has in the match

current_turn = 0         #The number of the most current turn.


# This file focuses on understanding how these arrays work.

my_move_history = []        #Array containing your previous moves
their_move_history = []     #Array containing the other script's previous moves



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


### Custom Variables
meaning_of_life = 42


#### Main Function (Write your code here) ##########################################
# This is the code that runs every turn to decide what to do.
# This function MUST return STEAL or return SUPPORT. Otherwise an error will occur.
####################################################################################

def steal_or_support():
    return arrays_failure()
    #return arrays_1()
    #return arrays_2()


# This function chooses what to do based on first impressions.
def arrays_1():
    if len(their_move_history) == 0:
        return STEAL

    if their_move_history[0] == SUPPORT:
        return SUPPORT
    else:
        return STEAL


def arrays_2():
    if len(their_move_history) == 0:
        return SUPPORT


def arrays_failure():
    return their_move_history[0]
    



###########    DO NOT TOUCH ANY CODE BELOW THIS POINT!    ###########
###########    DO NOT TOUCH ANY CODE BELOW THIS POINT!    ###########
###########    DO NOT TOUCH ANY CODE BELOW THIS POINT!    ###########
###########    DO NOT TOUCH ANY CODE BELOW THIS POINT!    ###########
###########    DO NOT TOUCH ANY CODE BELOW THIS POINT!    ###########
###########    DO NOT TOUCH ANY CODE BELOW THIS POINT!    ###########
###########    DO NOT TOUCH ANY CODE BELOW THIS POINT!    ###########
###########    DO NOT TOUCH ANY CODE BELOW THIS POINT!    ###########

def update(thismoney, theirmoney, currentturn, thisrecentturn, theirrecentturn):
    ''' Update all variables to be up to date with the current game state'''
    my_money = thismoney
    their_money = theirmoney
    current_turn = currentturn
    my_move_history.append(thisrecentturn)
    their_move_history.append(theirrecentturn)

def main(thismoney, theirmoney, currentturn, thisrecentturn, theirrecentturn):
    '''Manages this script. Run each turn.'''
    update(thismoney, theirmoney, currentturn, thisrecentturn, theirrecentturn)
    result = steal_or_support()
    return result
########################
##custom_variables.py ##
########################

# This default script is a basic script that will choose to steal for the first half of the match,
# and choose to support for the second half.

# The purpose of this file is to show how to use custom variables properly.
# To use a custom variable custom_variable, it should be defined above the steal_or_support function,
# Then at the start of the function, declare global custom_variable

# The reason for this is because of the way modules and variable scope work in python. It is too much 
# for the average primary/intermediate student to go over; however for the savvy student:

# This file gets imported into a wrapper class that runs the main function at the bottom of this file.
# In this wrapper class, all default variables are stored and managed. 
# When processing the steal_or_support function, references to default variables such as my_money
# work because the wrapper class dynamically updates the module's global namespace with the current
# game state values before calling the function. This allows read access to variables like my_money,
# their_money, etc., without needing to declare them as global.

# However, for custom variables that you define and modify within the steal_or_support function,
# you must declare them as global at the start of the function. This is because Python treats
# assignments to variables as local by default, and without the global declaration, any changes
# to the variable would create a new local variable instead of modifying the global one.
# The wrapper class does not manage custom variables, so you are responsible for handling their scope. 


# Constants 
STEAL = 0       
SUPPORT = 1     

# Default Variables 
my_money = 0          #How much money your script currently has in the match
their_money = 0       #How much money the other script currently has in the match

current_turn = 0         #The number of the most current turn.

my_move_history = []        #Array containing your previous moves
their_move_history = []     #Array containing the other script's previous moves


# Custom Variables
incrementer = 0


#### Main Function (Write your code here) ##########################################
# This is the code that runs every turn to decide what to do.
# This function MUST return STEAL or return SUPPORT. Otherwise an error will occur.
####################################################################################

# Steal for 25 turns,
# Then support for the remainder of the game.

def steal_or_support():
    #This line must exist at the start of the function for the variable to be accessible
    global incrementer 
    
    incrementer = incrementer + 1
    if incrementer >= 25:
        return SUPPORT
    else:
        return STEAL





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
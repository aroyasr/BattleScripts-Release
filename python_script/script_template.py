########################
## script_template.py ##
########################
# Welcome to BattleScripts! This is the file template for your script that you will submit as your BattleScript.


# Constants 
STEAL = 0       # Don't change these numbers...
SUPPORT = 1     # Unless you like ugly code and confusing yourself!

# Variables (Do not modify - These are updated automatically each turn)
my_money = 0          #How much money your script currently has in the match
their_money = 0       #How much money the other script currently has in the match

current_turn = 0         #The number of the most current turn

my_move_history = []        #Array containing your previous moves
their_move_history = []     #Array containing the other script's previous moves


# Custom Variables 
meaning_of_life = 42


#### Main Function (Write your code here) ##########################################
# This function MUST return STEAL or return SUPPORT. Otherwise an error will occur.
####################################################################################

def steal_or_support():
    #This is example code; if this script has no money, it will STEAL. If this script
    #has any money, it will SUPPORT. It's a very simple script; there's better strategies.
    #You can safely delete these comments and the code inside the main function.
    if my_money > 25:
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
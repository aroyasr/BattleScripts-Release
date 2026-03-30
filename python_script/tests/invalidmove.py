#test: invalid move


# Constants 
STEAL = 0     
SUPPORT = 1

# Variables (Do not modify - These are updated automatically each turn)
my_money = 0      
their_money = 0     

current_turn = 0      

my_move_history = []       
their_move_history = []     



def steal_or_support():
    return 2
    return 0


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
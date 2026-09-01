from enum import Enum, auto

class ACTIONS(Enum):
    STEAL = 0
    SUPPORT = 1

class Script():
    def __init__(self):
        self.my_money = 0
        self.their_money = 0
        self.current_turn = 0
        self.my_move_history = []
        self.their_move_history = []

    def steal_or_support(self):
        return ACTIONS.STEAL

    def update(self, my_money, their_money, current_turn, my_last_turn, their_last_turn):
        self.my_money = my_money
        self.their_money = their_money
        self.current_turn = current_turn
        self.my_move_history.append(my_last_turn)
        self.their_move_history.append(their_last_turn)

    def main(self, my_money, their_money, current_turn, my_last_turn, their_last_turn):
        self.update(my_money, their_money, current_turn, my_last_turn, their_last_turn)
        return self.steal_or_support()
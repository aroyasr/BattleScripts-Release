# Battlescripts

## What is BattleScripts?

Battlescripts is a turn based battle game where you will submit a python program that decides what to do each turn.

Your script will run against another persons script, and after 50 turns the game will end. The aim of the game is to get the most money. Each turn, you will get money. The amount of money you get will depend on how good your strategy is.

A basic understanding of python programming will be necessary.

## Turn options

Each turn, your script will have 2 options: Steal or Support.

Stealing is an offensive option that will earn you 3 points if the other player supports you,
However if the other player also chooses steal then both players will only get 1 point each.

Supporting is a defensive option that will earn you 2 points if the other player supports you,
However if the other player chooses steal then you will get 0 points.

[Graph of point dynamics.]

## Programming

You will be given a template script that you need to modify to make your own.

In the script, there is a function called |steal_or_support()|. Inside this function is how your script decides what to do.

The code inside this function runs every turn. 

You decide what to do by returning the STEAL or SUPPORT constants. 

[Explanation of what returning values is.]

You can access information about the game through the variables in the script. 

You can check how much money both scripts have using the |my_money| and |their_money| variables.

You can check all of the opponents previous moves using the |their_move_history| array.

## Strategies


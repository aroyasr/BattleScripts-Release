# BattleScripts

BattleScripts is a turn-based educational game developed to be ran in Tūhura Tech sessions. Students will write a script in python to act out a strategy, and compete against other scripts.

The game is based on the iterated prisoner's dillemma, a thought experiment in regards to if one should act in self interest or mutual benefit. In this game, players can either choose to steal from the other player or support the other player over many turns.

BattleScripts will run on the Lead Mentor's laptop and be played on a big screen. Students will work on their scripts on their own laptops and turn in their .py files to compete.

Students that do this excersize should become more familiar with the concept of functions, returning variables, storing variables, getting data, and conditional statements. They should also gain a better understanding of writing pseudocode, and planning in advance.

## tech stack

Godot for frontend, uploading python files, and watching a match play out.

Python handles game logic and returns results to godot each turn. they communicate over a 'comm_channel.json' file.

## script_template

script_template.py is a template for the students python script that they will submit. It includes some functions and variables by default for them to fill out. The main function is run each turn. Their function either returns STEAL or SUPPORT, where STEAL is the constant 1 and SUPPORT is the constant 0.

their script is then imported into a wrapper class PlayerWrapper, located in gm_main.py.

The gm_main.py file also contains the class GameManager which contains 2 PlayerWrappers and calculates their decision each turn.
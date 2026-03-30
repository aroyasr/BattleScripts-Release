extends Control

func _on_button_new_game_pressed() -> void:
	Root.new_game()

func _on_button_leaderboard_pressed() -> void:
	Root.leaderboard()

func _on_button_quit_pressed() -> void:
	Root.quit()

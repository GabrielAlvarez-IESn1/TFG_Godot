extends Control

@onready var leaderboard_scene = preload("res://Addons/silent_wolf/Scores/Leaderboard.tscn")

func _on_start_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.PLAYING)

func _on_scoreboard_button_pressed():
	get_tree().change_scene_to_packed(leaderboard_scene)

func _on_options_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.OPTIONS_MENU)

func _on_login_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.LOGIN)

func _on_quit_button_pressed():
	get_tree().quit()

extends Control

func _ready():
	pass

func _on_start_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.PLAYING)

func _on_scoreboard_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.SCOREBOARD)

func _on_options_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.OPTIONS_MENU)

func _on_quit_button_pressed():
	get_tree().quit()

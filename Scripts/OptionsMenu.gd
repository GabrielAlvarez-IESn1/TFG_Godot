extends Control

func _ready():
	pass

func _on_back_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU)

func _on_quit_button_pressed():
	get_tree().quit()

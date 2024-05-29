extends Control

func _on_submit_button_pressed():
	if $VBoxContainer/NameInput.text == "":
		$VBoxContainer/NameInput.focus_mode = Control.FOCUS_ALL
		$VBoxContainer/NameInput.focus_mode = Control.FOCUS_CLICK
		return
	GlobalData.log_player_in($VBoxContainer/NameInput.text)
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU)

func _on_back_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU)

func _on_quit_button_pressed():
	get_tree().quit()

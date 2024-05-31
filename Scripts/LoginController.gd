extends Control

func _on_submit_button_pressed():
	# Check if name is not empty
	if $VBoxContainer/NameInput.text == "":
		$VBoxContainer/NameInput.focus_mode = Control.FOCUS_ALL
		$VBoxContainer/NameInput.focus_mode = Control.FOCUS_CLICK
		return

	GlobalData.log_player_in($VBoxContainer/NameInput.text) # Log player in
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU) # Change scene

func _on_back_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU) # go back to main menu

func _on_quit_button_pressed():
	get_tree().quit() # Quit the game

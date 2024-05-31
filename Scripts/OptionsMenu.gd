extends Control

func _on_back_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU) # go back to main menu

func _on_quit_button_pressed():
	get_tree().quit() # Quit the game

func _on_master_volume_slider_value_changed(value:float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value)) # set master volume

func _on_music_volume_slider_value_changed(value:float):
	GlobalAudioPlayer.music_volume = linear_to_db(value) # set music volume

func _on_fx_volume_slider_value_changed(value:float):
	GlobalAudioPlayer.fx_volume = linear_to_db(value) # set fx volume

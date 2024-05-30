extends Control

func _on_back_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU)

func _on_quit_button_pressed():
	get_tree().quit()

func _on_master_volume_slider_value_changed(value:float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_music_volume_slider_value_changed(value:float):
	GlobalAudioPlayer.music_volume = linear_to_db(value)

func _on_fx_volume_slider_value_changed(value:float):
	GlobalAudioPlayer.fx_volume = linear_to_db(value)

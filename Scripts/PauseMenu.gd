extends Control

func _process(_delta):
	# Toggle the pause menu
	if Input.is_action_just_pressed("WASD_PAUSE") and SceneManager.game_state != SceneManager.GameState.WIN:
		if get_tree().paused:
			GlobalSignals.game_unpaused.emit() # unpause
		else:
			GlobalSignals.game_paused.emit() # pause

func _ready():
	# Connect the signals
	GlobalSignals.game_paused.connect(self._on_game_paused)
	GlobalSignals.game_unpaused.connect(self._on_game_unpaused)
	hide() # hide the pause menu

func _on_game_paused():
	# Pause the game
	get_tree().paused = true
	show()

func _on_game_unpaused():
	# Unpause the game
	get_tree().paused = false
	hide()

# BUTTONS
func _on_resume_button_pressed():
	# Unpause the game
	GlobalSignals.game_unpaused.emit()

func _on_restart_button_pressed():
	# Restart the level
	GlobalSignals.game_unpaused.emit()
	get_tree().reload_current_scene()

func _on_mainmenu_button_pressed():
	# Go to the main menu
	GlobalSignals.game_unpaused.emit()
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU)

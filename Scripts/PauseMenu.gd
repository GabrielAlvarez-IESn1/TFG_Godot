extends Control

func _process(_delta):
	if Input.is_action_just_pressed("WASD_PAUSE") and SceneManager.game_state != SceneManager.GameState.WIN:
		if get_tree().paused:
			GlobalSignals.game_unpaused.emit()
		else:
			GlobalSignals.game_paused.emit()

func _ready():
	GlobalSignals.game_paused.connect(self._on_game_paused)
	GlobalSignals.game_unpaused.connect(self._on_game_unpaused)
	hide()

func _on_game_paused():
	get_tree().paused = true
	show()

func _on_game_unpaused():
	get_tree().paused = false
	hide()

# BUTTONS
func _on_resume_button_pressed():
	GlobalSignals.game_unpaused.emit()

func _on_restart_button_pressed():
	GlobalSignals.game_unpaused.emit()
	get_tree().reload_current_scene()

func _on_mainmenu_button_pressed():
	GlobalSignals.game_unpaused.emit()
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU)

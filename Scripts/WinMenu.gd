extends Control

func _ready():
	GlobalSignals.game_state_changed.connect(self._on_game_state_changed)
	hide()

func _on_game_state_changed(state):
	if state == SceneManager.GameState.WIN:
		get_tree().paused = true
		show()

# BUTTONS
func _on_next_button_pressed():
	hide()
	get_tree().paused = false
	GlobalSignals.game_unpaused.emit()

func _on_restart_button_pressed():
	hide()
	get_tree().paused = false
	GlobalSignals.game_unpaused.emit()
	get_tree().reload_current_scene()

func _on_mainmenu_button_pressed():
	hide()
	get_tree().paused = false
	GlobalSignals.game_unpaused.emit()
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU)

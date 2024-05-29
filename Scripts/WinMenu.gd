extends Control

@onready var leaderboard_scene = preload("res://Addons/silent_wolf/Scores/Leaderboard.tscn")

func _ready():
	GlobalSignals.game_state_changed.connect(self._on_game_state_changed)
	hide()

func _on_game_state_changed(state):
	if state == SceneManager.GameState.WIN:
		get_tree().paused = true
		show()

# BUTTONS
func _on_scoreboard_button_pressed():
	hide()
	get_tree().paused = false
	GlobalSignals.game_unpaused.emit()
	get_tree().change_scene_to_packed(leaderboard_scene)

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

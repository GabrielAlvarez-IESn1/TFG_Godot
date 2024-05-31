extends Control

@onready var leaderboard_scene = preload("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func _ready():
	# Connect signals
	GlobalSignals.game_state_changed.connect(self._on_game_state_changed)
	hide() # hide the win menu

func _on_game_state_changed(state):
	# show the win menu
	if state == SceneManager.GameState.WIN:
		get_tree().paused = true # pause the game
		show() # show the pause menu

# BUTTONS
func _on_scoreboard_button_pressed():
	# Go to the leaderboard
	hide()
	get_tree().paused = false
	GlobalSignals.game_unpaused.emit()
	get_tree().change_scene_to_packed(leaderboard_scene)

func _on_restart_button_pressed():
	# Restart the level
	hide()
	get_tree().paused = false
	GlobalSignals.game_unpaused.emit()
	get_tree().reload_current_scene()

func _on_mainmenu_button_pressed():
	# Go to the main menu
	hide()
	get_tree().paused = false
	GlobalSignals.game_unpaused.emit()
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU)

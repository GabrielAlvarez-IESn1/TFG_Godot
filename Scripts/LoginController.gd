extends Control

var score = randi() % 101
var player_name = "Player"

@onready var leaderboard_scene = preload("res://Addons/silent_wolf/Scores/Leaderboard.tscn")

func _on_submit_button_pressed():
	player_name = $VBoxContainer/NameInput.text
	SilentWolf.Scores.save_score(player_name, score)
	get_tree().change_scene_to_packed(leaderboard_scene)

func _on_back_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.MAIN_MENU)

func _on_quit_button_pressed():
	get_tree().quit()

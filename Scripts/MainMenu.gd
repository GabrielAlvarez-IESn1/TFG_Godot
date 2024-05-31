extends Control

# Scene references
@onready var leaderboard_scene = preload("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func _ready():
	GlobalAudioPlayer.play_music_menu() # play menu music

	# check if player is logged in
	if GlobalData.player_logged_in:
		# show logged as text and let the player start the game
		$LoginBlocker.hide()
		$Login/LoggedAs.text = GlobalData.player_data.name
	else:
		# hide logged as text and don't let the player start the game
		$LoginBlocker.show()
		$Login/LoggedAs.text = "Not logged yet"

func _on_start_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.PLAYING) # start the game

func _on_scoreboard_button_pressed():
	get_tree().change_scene_to_packed(leaderboard_scene) # show leaderboard

func _on_options_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.OPTIONS_MENU) # show options

func _on_login_button_pressed():
	SceneManager.change_game_state(SceneManager.GameState.LOGIN) # show login

func _on_quit_button_pressed():
	get_tree().quit() # quit the game

extends Node

enum GameState {
	MAIN_MENU,
	SCOREBOARD,
	OPTIONS_MENU,
	LOGIN,
	PLAYING,
	GAMEOVER,
	WIN,
}

var game_state = GameState.MAIN_MENU

func _ready():
	GlobalSignals.connect("game_state_changed", self._on_game_state_changed)

func change_game_state(state):
	game_state = state
	GlobalSignals.emit_signal("game_state_changed", game_state)

func _on_game_state_changed(state):
	match state:
		GameState.MAIN_MENU:
			get_tree().change_scene_to_file(GlobalScenes.scenes["main"])
		GameState.SCOREBOARD:
			get_tree().change_scene_to_file(GlobalScenes.scenes["scoreboard"])
		GameState.OPTIONS_MENU:
			get_tree().change_scene_to_file(GlobalScenes.scenes["options"])
		GameState.PLAYING:
			get_tree().change_scene_to_file(GlobalScenes.scenes["game"])
		GameState.LOGIN:
			get_tree().change_scene_to_file(GlobalScenes.scenes["login"])
		GameState.GAMEOVER:
			print("Gameover")
		GameState.WIN:
			print("Win")

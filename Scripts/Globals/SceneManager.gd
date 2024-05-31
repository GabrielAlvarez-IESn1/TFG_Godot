extends Node

# GAME STATES
enum GameState {
	MAIN_MENU,
	SCOREBOARD,
	OPTIONS_MENU,
	LOGIN,
	PLAYING,
	WIN,
}

# First scene to load
var game_state = GameState.MAIN_MENU

func _ready():
	# Connect signals
	GlobalSignals.game_state_changed.connect(self._on_game_state_changed)

func change_game_state(state):
	# Change the game state
	GlobalSignals.game_state_changed.emit(state)

func _on_game_state_changed(state):
	# Change the scene
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
		GameState.WIN:
			pass # Nothing to do here

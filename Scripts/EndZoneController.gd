class_name EndZone
extends Area2D

func end_level():
	GlobalSignals.end_zone_reached.emit() # emit signal
	SceneManager.change_game_state(SceneManager.GameState.WIN) # change scene
	queue_free() # free self

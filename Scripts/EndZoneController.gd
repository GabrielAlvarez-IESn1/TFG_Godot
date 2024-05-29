class_name EndZone
extends Area2D

func end_level():
	GlobalSignals.end_zone_reached.emit()
	SceneManager.change_game_state(SceneManager.GameState.WIN)
	queue_free()

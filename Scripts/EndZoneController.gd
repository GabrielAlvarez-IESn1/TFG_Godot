class_name  EndZone
extends Area2D

func _on_area_entered(area):
	if area.is_in_group("Player"):
		GlobalSignals.end_zone_reached.emit()
		SceneManager.change_game_state(SceneManager.GameState.WIN)
		queue_free()

class_name CrystalController
extends Area2D


func _on_area_entered(area):
	if area.is_in_group("Player"):
		Signals.emit_signal("crystal_taken", get_name())
		queue_free()


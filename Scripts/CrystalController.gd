extends Area2D

signal crystal_picked_up(crystal_type)

var crystal_type


func _ready():
	crystal_type = get_name()


func _on_area_entered(area):
	if area.is_in_group("Player"):
		emit_signal("crystal_picked_up", crystal_type)
		queue_free()


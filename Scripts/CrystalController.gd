class_name CrystalController
extends Area2D

func _on_area_entered(area):
	if area.is_in_group("Player"):
		GlobalSignals.emit_signal("crystal_taken", get_crystal_type())
		queue_free()

func get_crystal_type() -> GlobalTypes.Crystals:
	var crystal_type = GlobalTypes.Crystals.NONE
	var crystal_name = get_name()

	if crystal_name.find("Red") != - 1:
		crystal_type = GlobalTypes.Crystals.FIRE
	elif crystal_name.find("Yellow") != - 1:
		crystal_type = GlobalTypes.Crystals.LIGHTNING
	elif crystal_name.find("Green") != - 1:
		crystal_type = GlobalTypes.Crystals.PLANT
	elif crystal_name.find("Blue") != - 1:
		crystal_type = GlobalTypes.Crystals.WATER

	return crystal_type

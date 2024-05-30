class_name CrystalController
extends Area2D

@onready var impact_hit_fx = preload("res://Audio/impact_hit.mp3")
@onready var crystal_pickup_fx = preload("res://Audio/crystal_brake.mp3")

func take_crystal():
	GlobalSignals.crystal_taken.emit(self.get_crystal_type())
	AudioPlayer.play_FX(impact_hit_fx)
	AudioPlayer.play_FX(crystal_pickup_fx)
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

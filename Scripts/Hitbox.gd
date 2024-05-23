extends Area2D

func _ready():
	$Hitbox.disabled = true

func activate_hitbox():
	$Hitbox.disabled = false

func deactivate_hitbox():
	$Hitbox.disabled = true

func _on_area_entered(area:Area2D):
	print(area.name)
	if area.is_in_group("Crystal"):
		area.take_crystal()

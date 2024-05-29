extends Area2D

func _ready():
	$Hitbox.disabled = true

func activate_hitbox():
	await (get_tree().create_timer(0.1).timeout)
	$Hitbox.disabled = false

func deactivate_hitbox():
	$Hitbox.disabled = true

func _on_area_entered(area:Area2D):
	if area.is_in_group("Crystal"):
		area.take_crystal()

	if area.is_in_group("End"):
		area.end_level()

extends Area2D

func _ready():
	$Hitbox.disabled = true # disable the hitbox

func activate_hitbox():
	await (get_tree().create_timer(0.05).timeout) # wait 0.05 seconds
	$Hitbox.disabled = false # enable the hitbox

func deactivate_hitbox():
	$Hitbox.disabled = true # disable the hitbox

func _on_area_entered(area:Area2D):
	# Check the area group
	if area.is_in_group("Crystal"):
		area.take_crystal() # take the crystal

	if area.is_in_group("End"):
		area.end_level() # end the level

extends CharacterBody2D

const JUMP_VELOCITY = -600.0
const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.1

@onready var spawnTimer = $SpawnTimer

var animation_tree: AnimationTree
var state_machine: AnimationNodeStateMachinePlayback
var hitbox_area: Area2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5
var coyote_timer = 0.0
var is_attacking = false
var movement_speed = 300.0
var jump_buffer_timer = 0.0
var direction = Vector2()
var is_dashing = false
var is_gliding = false
var is_stomping = false

var last_card_used = GlobalTypes.Cards.NONE
var current_card = GlobalTypes.Cards.NONE

@onready var fire_fx = preload("res://Audio/fire_ability.mp3")
@onready var lightning_fx = preload("res://Audio/lightning_ability.mp3")
@onready var plant_fx = preload("res://Audio/plant_ability.mp3")
@onready var water_fx = preload("res://Audio/water_ability.mp3")

func _ready():
	# Default properties
	self.slide_on_ceiling = true

	# Hitbox
	hitbox_area = $HitboxArea

	# Animations
	animation_tree = $AnimationTree
	animation_tree.active = true
	state_machine = animation_tree.get("parameters/playback")
	animation_tree.connect("animation_finished", self._on_animation_finished)

	# Handle the spawn
	set_physics_process(false)
	await spawnTimer.timeout
	animation_tree.set("parameters/conditions/is_spawned", true)
	set_physics_process(true)

	# Connect the crystal taken signal
	GlobalSignals.connect("crystal_taken", self.on_crystal_taken)

func _physics_process(delta):
	# Update the animation parameters
	self._update_animation_parameters()

	# Decrease the coyote timer if it's running
	if coyote_timer > 0:
		coyote_timer -= delta

	# Add the gravity
	if not is_on_floor() and not is_gliding:
		velocity.y += gravity * delta

	# Reset the coyote timer when on floor
	if is_on_floor():
		coyote_timer = COYOTE_TIME

	# Handle jump
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	if ((Input.is_action_just_pressed("WASD_SPACEBAR") and coyote_timer > 0) or (is_on_floor() and jump_buffer_timer > 0)) and not is_gliding:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0
		jump_buffer_timer = 0

	# Get the input direction and handle the movement/deceleration
	direction = Input.get_axis("WASD_A", "WASD_D")

	# Move the player
	if not is_dashing and not is_stomping:
		if is_attacking:
			if is_on_floor():
				velocity.x = lerp(velocity.x, velocity.x * 0.5, 0.1)
			else:
				velocity.x = lerp(velocity.x, velocity.x * 0.8, 0.1)
		else:
			if direction:
				velocity.x = direction * movement_speed

				if direction < 0:
					$AnimatedSprite2D.flip_h = true
					hitbox_area.get_child(0).position.x = -hitbox_area.get_child(0).position.x
				else:
					$AnimatedSprite2D.flip_h = false
					hitbox_area.get_child(0).position.x = abs(hitbox_area.get_child(0).position.x)
			else:
				velocity.x = move_toward(velocity.x, 0, movement_speed)

	move_and_slide()

# Handle input
func _input(event):
	# Handle attack
	if event.is_action_pressed("WASD_PRIMARY_ATTACK"):
		if not is_attacking:
			is_attacking = true
			state_machine.travel("Attack1")
			hitbox_area.activate_hitbox()
		else:
			state_machine.travel("Attack2")

	# Handle habilities
	if event.is_action_pressed("WASD_SECONDARY_ATTACK"):
		if current_card != last_card_used:
			last_card_used = current_card
			GlobalSignals.card_used.emit(current_card)

			match current_card:
				GlobalTypes.Cards.FIRE:
					GlobalAudioPlayer.play_FX(fire_fx)
					velocity.y = JUMP_VELOCITY * 1.25
				GlobalTypes.Cards.LIGHTNING:
					GlobalAudioPlayer.play_FX(lightning_fx)
					is_dashing = true
					movement_speed -= 300
					velocity.x = lerp(velocity.x, velocity.x * 100, 0.1)
					await (get_tree().create_timer(0.1).timeout)
					movement_speed += 300
					is_dashing = false
				GlobalTypes.Cards.PLANT:
					GlobalAudioPlayer.play_FX(plant_fx)
					is_gliding = true
					velocity.y = 0
					await (get_tree().create_timer(1).timeout)
					is_gliding = false
				GlobalTypes.Cards.WATER:
					GlobalAudioPlayer.play_FX(water_fx)
					is_stomping = true
					velocity.x = 0
					velocity.y = 0
					await (get_tree().create_timer(0.1).timeout)
					velocity.y = lerp(0, 10000, 0.3)
					await (get_tree().create_timer(0.3).timeout)
					is_stomping = false
				GlobalTypes.Cards.NONE:
					print("PM: No card selected")
				_:
					print("PM: Unknown card: ", current_card)
		current_card = GlobalTypes.Cards.NONE

	# Handle jump buffer
	if event.is_action_pressed("WASD_SPACEBAR"):
		jump_buffer_timer = JUMP_BUFFER_TIME

	# DEBUG: Teleport the player to the mouse position
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_position = get_global_mouse_position()
		global_position = mouse_position

	# Restart the scene when R is pressed
	if event.is_action_pressed("WASD_RESTART"):
		get_tree().reload_current_scene()

# Update the animation parameters
func _update_animation_parameters():
	animation_tree.set("parameters/conditions/idle", velocity.x == 0 and is_on_floor())
	animation_tree.set("parameters/conditions/running", velocity.x != 0 and is_on_floor())
	animation_tree.set("parameters/conditions/jumping", not is_on_floor() and velocity.y < 0)
	animation_tree.set("parameters/conditions/falling", not is_on_floor() and velocity.y >= 0)

# Handle the animation finished signal
func _on_animation_finished(anim_name):
	if anim_name == "Attack1" and not state_machine.get_current_node() == "Attack2":
		is_attacking = false
		hitbox_area.deactivate_hitbox()
	elif anim_name == "Attack2":
		is_attacking = false
		hitbox_area.deactivate_hitbox()

# Handle the crystal taken signal
func on_crystal_taken(crystal_type: GlobalTypes.Crystals):
	last_card_used = GlobalTypes.Cards.NONE
	match crystal_type:
		GlobalTypes.Crystals.FIRE:
			current_card = GlobalTypes.Cards.FIRE
		GlobalTypes.Crystals.LIGHTNING:
			current_card = GlobalTypes.Cards.LIGHTNING
		GlobalTypes.Crystals.PLANT:
			current_card = GlobalTypes.Cards.PLANT
		GlobalTypes.Crystals.WATER:
			current_card = GlobalTypes.Cards.WATER
		_:
			current_card = GlobalTypes.Cards.NONE

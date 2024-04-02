class_name PlayerController
extends CharacterBody2D

const JUMP_VELOCITY = -400.0
const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.1

@onready var spawnTimer = $SpawnTimer

var animated_sprite : AnimatedSprite2D
var animation_tree : AnimationTree
var animation_player : AnimationPlayer
var state_machine : AnimationNodeStateMachinePlayback

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyote_timer = 0.0
var is_attacking = false
var movement_speed = 200.0
var jump_buffer_timer = 0.0


func _ready():
	# Default properties
	slide_on_ceiling = true

	# Animations
	animated_sprite = $AnimatedSprite2D
	animation_tree = $AnimationTree
	animation_tree.active = true
	animation_player = $AnimationPlayer
	state_machine = animation_tree.get("parameters/playback")
	animation_tree.connect("animation_finished", self._on_animation_finished)

	# Handle the spawn
	set_physics_process(false)
	await spawnTimer.timeout
	animation_tree.set("parameters/conditions/is_spawned", true)
	set_physics_process(true)


func _physics_process(delta):
	# Update the animation parameters
	self._update_animation_parameters()

	# Decrease the coyote timer if it's running
	if coyote_timer > 0:
		coyote_timer -= delta

	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Reset the coyote timer when on floor
	if is_on_floor():
		coyote_timer = COYOTE_TIME

	# Handle jump
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	if (Input.is_action_just_pressed("WASD_SPACEBAR") and coyote_timer > 0) or (is_on_floor() and jump_buffer_timer > 0):
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0
		jump_buffer_timer = 0

	# Get the input direction and handle the movement/deceleration
	var direction = Input.get_axis("WASD_A", "WASD_D")

	# Move the player
	if is_attacking:
		if is_on_floor():
			velocity.x = lerp(velocity.x, velocity.x * 0.5, 0.1)
		else:
			velocity.x = lerp(velocity.x, velocity.x * 0.8, 0.1)
	else:
		if direction:
			velocity.x = direction * movement_speed

			if direction < 0:
				animated_sprite.flip_h = true
			else:
				animated_sprite.flip_h = false
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
		else:
			state_machine.travel("Attack2")

	if event.is_action_pressed("WASD_SPACEBAR"):
		jump_buffer_timer = JUMP_BUFFER_TIME

	# DEBUG: Teleport the player to the mouse position
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_position = get_global_mouse_position()
		global_position = mouse_position

	# DEBUG: Restart the scene when R is pressed
	if event.is_action_pressed("WASD_RESTART"):
		get_tree().reload_current_scene()

	# DEBUG: Exit the game when ESC is pressed
	if event.is_action_pressed("WASD_EXIT"):
		get_tree().quit()

# Update the animation parameters
func _update_animation_parameters():
	animation_tree.set("parameters/conditions/idle", velocity.x == 0 and is_on_floor())
	animation_tree.set("parameters/conditions/running", velocity.x != 0 and is_on_floor())
	animation_tree.set("parameters/conditions/jumping", not is_on_floor() and velocity.y < 0)
	animation_tree.set("parameters/conditions/falling", not is_on_floor() and velocity.y >= 0)

func _on_animation_finished(anim_name):
	if anim_name == "Attack1" and not state_machine.get_current_node() == "Attack2":
		is_attacking = false
	elif anim_name == "Attack2":
		is_attacking = false

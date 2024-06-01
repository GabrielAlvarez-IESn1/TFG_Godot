extends CharacterBody2D

# Constants
const JUMP_VELOCITY = -600.0
const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.1

# Variables
# 	Movement
var direction = Vector2() # The player's direction
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 1.5 # The player's gravity
var movement_speed = 300.0 # The player's movement speed

# 	Animation
var state_machine: AnimationNodeStateMachinePlayback # The player's state machine

# 	Action state
var is_attacking = false
var is_dashing = false
var is_gliding = false
var is_stomping = false

# 	Actions
var coyote_timer = 0.0 # How long the player can still jump after leaving the ground
var jump_buffer_timer = 0.0 # How long the player can still jump before landing

# 	Cards
var last_card_used = GlobalTypes.Cards.NONE # The player's last card used
var current_card = GlobalTypes.Cards.NONE # The player's current card

#	Audio
@onready var fire_fx = preload("res://audio/fire_ability.mp3")
@onready var lightning_fx = preload("res://audio/lightning_ability.mp3")
@onready var plant_fx = preload("res://audio/plant_ability.mp3")
@onready var water_fx = preload("res://audio/water_ability.mp3")

# Nodes
@onready var spawnTimer = $SpawnTimer # The player's spawn timer
@onready var hitbox_area = $HitboxArea # The player's hitbox
@onready var animation_tree = $AnimationTree # The player's animation

func _ready():
	self.slide_on_ceiling = true # The player can slide on the ceiling

	# Animations
	animation_tree.active = true # Enable the animation tree
	state_machine = animation_tree.get("parameters/playback") # Get the player's state machine
	animation_tree.connect("animation_finished", self._on_animation_finished) # Connect the animation finished signal

	# Handle the spawn
	set_physics_process(false) # Disable the physics process
	await spawnTimer.timeout # Wait for the player to spawn
	animation_tree.set("parameters/conditions/is_spawned", true) # Set the player's animation
	set_physics_process(true) # Enable the physics process

	GlobalSignals.connect("crystal_taken", self.on_crystal_taken) # Connect the crystal taken signal

func _physics_process(delta):
	self._update_animation_parameters() # Update the animation parameters

	# Handle the coyote timer
	if coyote_timer > 0:
		coyote_timer -= delta

	# Add the gravity
	if not is_on_floor() and not is_gliding:
		velocity.y += gravity * delta

	# Reset the coyote timer when on floor
	if is_on_floor():
		coyote_timer = COYOTE_TIME

	# Handle the jump buffer timer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	# Handle the jump
	if ((Input.is_action_just_pressed("WASD_SPACEBAR") and coyote_timer > 0) or (is_on_floor() and jump_buffer_timer > 0)) and not is_gliding:
		velocity.y = JUMP_VELOCITY # Add the jump velocity
		coyote_timer = 0 # Reset the coyote timer
		jump_buffer_timer = 0 # Reset the jump buffer timer

	# Get the input direction
	direction = Input.get_axis("WASD_A", "WASD_D")

	# Move the player
	if not is_dashing and not is_stomping: # Don't move if dashing or stomping
		# Slow the player when attacking
		if is_attacking:
			# Slow the player less in the air when attacking
			if is_on_floor():
				velocity.x = lerp(velocity.x, velocity.x * 0.5, 0.1)
			else:
				velocity.x = lerp(velocity.x, velocity.x * 0.8, 0.1)
		else:
			if direction:
				# Move the player
				velocity.x = direction * movement_speed

				# Flip the sprite and hitbox based on direction
				if direction < 0:
					$AnimatedSprite2D.flip_h = true
					hitbox_area.get_child(0).position.x = -hitbox_area.get_child(0).position.x
				else:
					$AnimatedSprite2D.flip_h = false
					hitbox_area.get_child(0).position.x = abs(hitbox_area.get_child(0).position.x)
			else:
				# Slow the player when not moving
				velocity.x = move_toward(velocity.x, 0, movement_speed)

	move_and_slide() # Move and detect collisions

# Handle input
func _input(event):
	# Handle attack
	if event.is_action_pressed("WASD_PRIMARY_ATTACK"):
		if not is_attacking:
			# If it's not attacking, switch to the first attack
			is_attacking = true
			state_machine.travel("Attack1") # Play the first attack animation
			hitbox_area.activate_hitbox() # Activate the hitbox
		else:
			# If it's already attacking, switch to the second attack
			state_machine.travel("Attack2") # Play the second attack animation

	# Handle habilities
	if event.is_action_pressed("WASD_SECONDARY_ATTACK"):
		# Don't let the player spam the card
		if current_card != last_card_used:
			last_card_used = current_card # Set the last card used
			GlobalSignals.card_used.emit(current_card) # Emit the card used signal

			# Use the card, play the corresponding sound effect
			match current_card:
				GlobalTypes.Cards.FIRE: # Double jump
					GlobalAudioPlayer.play_FX(fire_fx)
					velocity.y = JUMP_VELOCITY * 1.25
					current_card = GlobalTypes.Cards.NONE

				GlobalTypes.Cards.LIGHTNING: # Dash
					GlobalAudioPlayer.play_FX(lightning_fx)
					is_dashing = true
					movement_speed -= 300
					velocity.x = lerp(velocity.x, velocity.x * 100, 0.1)
					current_card = GlobalTypes.Cards.NONE
					await (get_tree().create_timer(0.1).timeout)
					movement_speed += 300
					is_dashing = false

				GlobalTypes.Cards.PLANT: # Lateral glide
					GlobalAudioPlayer.play_FX(plant_fx)
					is_gliding = true
					velocity.y = 0
					current_card = GlobalTypes.Cards.NONE
					await (get_tree().create_timer(1).timeout)
					is_gliding = false

				GlobalTypes.Cards.WATER: # Stomp to the floor
					GlobalAudioPlayer.play_FX(water_fx)
					is_stomping = true
					velocity.x = 0
					velocity.y = 0
					current_card = GlobalTypes.Cards.NONE
					await (get_tree().create_timer(0.1).timeout)
					velocity.y = lerp(0, 10000, 0.3)
					await (get_tree().create_timer(0.3).timeout)
					is_stomping = false

	# Handle jump buffer
	if event.is_action_pressed("WASD_SPACEBAR"):
		jump_buffer_timer = JUMP_BUFFER_TIME # Start the jump buffer timer

	# Restart the scene when R is pressed
	if event.is_action_pressed("WASD_RESTART"):
		get_tree().reload_current_scene() # Reload the current scene

# Update the animation parameters
func _update_animation_parameters():
	animation_tree.set("parameters/conditions/idle", velocity.x == 0 and is_on_floor()) # Set the idle animation
	animation_tree.set("parameters/conditions/running", velocity.x != 0 and is_on_floor()) # Set the running animation
	animation_tree.set("parameters/conditions/jumping", not is_on_floor() and velocity.y < 0) # Set the jumping animation
	animation_tree.set("parameters/conditions/falling", not is_on_floor() and velocity.y >= 0) # Set the falling animation

# Handle the animation finished signal
func _on_animation_finished(anim_name):
	# Handle the attack animations
	if anim_name == "Attack1" and not state_machine.get_current_node() == "Attack2":
		# If the first attack is done, switch back to idle
		is_attacking = false
		hitbox_area.deactivate_hitbox()
	elif anim_name == "Attack2":
		# If the second attack is done, switch back to idle
		is_attacking = false
		hitbox_area.deactivate_hitbox()

# Handle the crystal taken signal
func on_crystal_taken(crystal_type: GlobalTypes.Crystals):
	last_card_used = GlobalTypes.Cards.NONE # Reset the last card used
	# Update the current card
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

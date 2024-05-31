extends Node

# Signals
signal player_logged_in() # player logged in

signal crystal_taken(crystal_type) # crystal taken
signal card_used(card_type) # card used

signal game_state_changed(game_state) # game state changed

signal game_paused() # game paused
signal game_unpaused() # game unpaused

signal end_zone_reached() # end zone reached

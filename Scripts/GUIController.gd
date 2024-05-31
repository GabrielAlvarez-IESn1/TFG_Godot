extends CanvasLayer

var timeElapsed = 0 # time elapsed in seconds

func _ready():
	GlobalAudioPlayer.play_music_level() # play level music

	# Connect the signals
	GlobalSignals.crystal_taken.connect(self.on_crystal_taken)
	GlobalSignals.card_used.connect(self.on_card_used)
	GlobalSignals.end_zone_reached.connect(self.on_end_zone_reached)

	# Start the timer
	$Timer/Clock.wait_time = 1

	$Score.visible = false # hide score

# Handle the crystal taken signal
func on_crystal_taken(crystal_type: GlobalTypes.Crystals):
	# Show the corresponding ability card
	if crystal_type != GlobalTypes.Crystals.NONE:
		show_card(crystal_type)

func on_card_used(card_type: GlobalTypes.Cards):
	# Hide the corresponding ability card
	if card_type != GlobalTypes.Cards.NONE:
		hide_card(card_type)

func show_card(crystal_type: GlobalTypes.Crystals):
	# Hide all cards
	$Panels/PanelFire.visible = false
	$Panels/PanelLightning.visible = false
	$Panels/PanelPlant.visible = false
	$Panels/PanelWater.visible = false

	# Show the corresponding card
	match crystal_type:
		GlobalTypes.Crystals.FIRE:
			$Panels/PanelFire.visible = true
		GlobalTypes.Crystals.LIGHTNING:
			$Panels/PanelLightning.visible = true
		GlobalTypes.Crystals.PLANT:
			$Panels/PanelPlant.visible = true
		GlobalTypes.Crystals.WATER:
			$Panels/PanelWater.visible = true

func hide_card(card_type: GlobalTypes.Cards):
	# Hide the corresponding card
	match card_type:
		GlobalTypes.Cards.FIRE:
			$Panels/PanelFire.visible = false
		GlobalTypes.Cards.LIGHTNING:
			$Panels/PanelLightning.visible = false
		GlobalTypes.Cards.PLANT:
			$Panels/PanelPlant.visible = false
		GlobalTypes.Cards.WATER:
			$Panels/PanelWater.visible = false

func _on_timer_timeout():
	# Update the timer
	timeElapsed += 1 # increment time every second
	var minutes = int(timeElapsed / 60.0) # get minutes
	var seconds = timeElapsed % 60 # get seconds
	$Timer/Label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) # update label with formatted time (mm:ss)

func on_end_zone_reached():
	$Score.visible = true # show score
	$Score/ScoreNumber.text = str(abs(1000 - timeElapsed)) # set score number
	GlobalData.player_data.score = abs(1000 - timeElapsed) # set player score

	# Save score on SilentWolf leaderboard
	await SilentWolf.Scores.save_score(GlobalData.player_data.name, GlobalData.player_data.score).sw_save_score_complete

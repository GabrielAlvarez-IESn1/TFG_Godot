extends CanvasLayer

var timeElapsed = 0

func _ready():
	AudioPlayer.play_music_level()
	GlobalSignals.crystal_taken.connect(self.on_crystal_taken)
	GlobalSignals.card_used.connect(self.on_card_used)
	GlobalSignals.end_zone_reached.connect(self.on_end_zone_reached)
	$Timer/Clock.wait_time = 1
	$Score.visible = false

# Handle the crystal taken signal
func on_crystal_taken(crystal_type: GlobalTypes.Crystals):
	if crystal_type != GlobalTypes.Crystals.NONE:
		show_card(crystal_type)

func on_card_used(card_type: GlobalTypes.Cards):
	if card_type != GlobalTypes.Cards.NONE:
		hide_card(card_type)

func show_card(crystal_type: GlobalTypes.Crystals):
	$Panels/PanelFire.visible = false
	$Panels/PanelLightning.visible = false
	$Panels/PanelPlant.visible = false
	$Panels/PanelWater.visible = false

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
	timeElapsed += 1
	var minutes = int(timeElapsed / 60.0)
	var seconds = timeElapsed % 60
	$Timer/Label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)

func on_end_zone_reached():
	$Score.visible = true
	$Score/ScoreNumber.text = str(abs(1000 - timeElapsed))
	GlobalData.player_data.score = abs(1000 - timeElapsed)
	# var top_score = await SilentWolf.Scores.get_top_score_by_player(GlobalData.player_data.name).sw_top_player_score_complete

	await SilentWolf.Scores.save_score(GlobalData.player_data.name, GlobalData.player_data.score).sw_save_score_complete

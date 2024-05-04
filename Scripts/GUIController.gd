extends CanvasLayer

var timeElapsed = 0

func _ready():
	GlobalSignals.crystal_taken.connect(self.on_crystal_taken)
	GlobalSignals.card_used.connect(self.on_card_used)
	$Timer/Clock.wait_time = 1

# Handle the crystal taken signal
func on_crystal_taken(crystal_type: GlobalTypes.Crystals):
	if crystal_type != GlobalTypes.Crystals.NONE:
		show_card(crystal_type)
	else:
		print("GUI: Unknown crystal type: ", crystal_type)

func on_card_used(card_type: GlobalTypes.Cards):
	if card_type != GlobalTypes.Cards.NONE:
		hide_card(card_type)
	else:
		print("GUI: No card available")

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
		GlobalTypes.Crystals.NONE:
			print("GUI: No card to show")

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
		GlobalTypes.Cards.NONE:
			print("GUI: No card to hide")

func _on_timer_timeout():
	timeElapsed += 1
	var minutes = int(timeElapsed / 60.0)
	var seconds = timeElapsed % 60
	$Timer/Label.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)

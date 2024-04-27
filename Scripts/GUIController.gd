class_name GUIController
extends CanvasLayer

func _ready():
	GlobalSignals.connect("crystal_taken", self.on_crystal_taken)
	GlobalSignals.connect("card_used", self.on_card_used)

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
	$Control/PanelFire.visible = false
	$Control/PanelLightning.visible = false
	$Control/PanelPlant.visible = false
	$Control/PanelWater.visible = false

	match crystal_type:
		GlobalTypes.Crystals.FIRE:
			$Control/PanelFire.visible = true
		GlobalTypes.Crystals.LIGHTNING:
			$Control/PanelLightning.visible = true
		GlobalTypes.Crystals.PLANT:
			$Control/PanelPlant.visible = true
		GlobalTypes.Crystals.WATER:
			$Control/PanelWater.visible = true
		GlobalTypes.Crystals.NONE:
			print("GUI: No card to show")

func hide_card(card_type: GlobalTypes.Cards):
	match card_type:
		GlobalTypes.Cards.FIRE:
			$Control/PanelFire.visible = false
		GlobalTypes.Cards.LIGHTNING:
			$Control/PanelLightning.visible = false
		GlobalTypes.Cards.PLANT:
			$Control/PanelPlant.visible = false
		GlobalTypes.Cards.WATER:
			$Control/PanelWater.visible = false
		GlobalTypes.Cards.NONE:
			print("GUI: No card to hide")

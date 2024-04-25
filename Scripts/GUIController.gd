class_name GUIController
extends CanvasLayer


func _ready():
	Signals.connect("crystal_taken", self.on_crystal_taken)
	Signals.connect("card_used", self.on_card_used)


# Handle the crystal taken signal
func on_crystal_taken(crystal_type):
	match crystal_type:
		"CrystalRed":
			$Control/Panel1.visible = true
		"CrystalYellow":
			$Control/Panel2.visible = true
		"CrystalGreen":
			$Control/Panel3.visible = true
		"CrystalBlue":
			$Control/Panel4.visible = true
		_:
			print("Unknown crystal type: ", crystal_type)


func on_card_used(card_type):
	match card_type:
		"fire":
			$Control/Panel1.visible = false
		"lightning":
			$Control/Panel2.visible = false
		"plant":
			$Control/Panel3.visible = false
		"water":
			$Control/Panel4.visible = false
		"none":
			print("NO CARD AVAILABLE")
		_:
			print("Unknown card: ", card_type)

extends Panel

@onready var label: Label = $VBoxContainer/Label
@onready var label_4: Label = $VBoxContainer/Label4
@onready var label_5: Label = $VBoxContainer/Label5

func _process(delta: float) -> void:
	label.text = str(GameState.health) + "                                                                         " + str(GameState.health + 1)
	label_4.text = str(GameState.Coin) + "/5"
	label_5.text = str(GameState.Crystal) + "/2"

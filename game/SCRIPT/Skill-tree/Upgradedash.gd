extends Panel
@onready var label: Label = $VBoxContainer/Label
@onready var label_4: Label = $VBoxContainer/Label4
@onready var label_5: Label = $VBoxContainer/Label5

func _process(delta: float) -> void:
	label.text=(str(GameState.dashNum)+"                                                                         "+str(GameState.dashNum+1))
	label_4.text =( str(GameState.Coin)+"/10")
	label_5.text =( str(GameState.Crystal)+"/5")
	if GameState.dashNum == 3:
		pass

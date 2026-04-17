extends Button
@onready var button: Button = $"."
@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var sprite_2d_2: Sprite2D = $"../Sprite2D2"
@onready var label_3: Label = $"../Label3"
@onready var label_2: Label = $"../Label2"

func _process(delta):
	if button.button_pressed:
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_gray.png")
	elif button.is_hovered():
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_gray-HOVER.png")
	else:
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_gray.png")
func _on_button_down() -> void:
	button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_gray-PUSH.png")

func _ready() -> void:
	if GameState.tier ==1:
		sprite_2d.texture=preload("res://ASSETS/character/PNG/Swordsman_lvl1/Without_shadow/Swordsman_lvl1_Idle_without_shadow.png")
		sprite_2d_2.texture=preload("res://ASSETS/character/PNG/Swordsman_lvl2/Without_shadow/Swordsman_lvl2_Idle_without_shadow.png")
		label_3.text = ("REQUIRED KILLS:"+str(GameState.Kill)+"/2")
		label_2.text = ("Damage +2, Speed: +30, health +3")
	elif GameState.tier ==2:
		sprite_2d_2.texture=preload("res://ASSETS/character/PNG/Swordsman_lvl3/Without_shadow/Swordsman_lvl3_Idle_without_shadow.png")
		sprite_2d.texture=preload("res://ASSETS/character/PNG/Swordsman_lvl2/Without_shadow/Swordsman_lvl2_Idle_without_shadow.png")
		label_3.text = ("REQUIRED KILLS:"+str(GameState.Kill)+"/4")
		label_2.text = ("Damage +3, Speed: +70, health +5")
	else:
		sprite_2d.texture=preload("res://ASSETS/character/PNG/Swordsman_lvl3/Without_shadow/Swordsman_lvl3_Idle_without_shadow.png")
		sprite_2d_2.texture = null
		label_3.text = ("MORE LEVELS SOON")
		label_2.queue_free()
func _on_button_up() -> void:
	button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_gray.png")
	if GameState.tier ==1:
		if GameState.Kill>=2:
			GameState.Kill -=2
			GameState.upgrade_tier()
			get_tree().reload_current_scene()
		else:
			return
	elif GameState.tier ==2:
		if GameState.Kill>=4:
			GameState.Kill -=4
			GameState.upgrade_tier()
			get_tree().reload_current_scene()
		else:
			return

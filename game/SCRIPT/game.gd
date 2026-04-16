extends Node

@onready var coin: Label = $COIN/COIN
@onready var crystal: Label = $CRYSTAL/CRYSTAL
@onready var kill: Label = $TextureRect/KILL

func _process(delta):
	coin.text = "COINS: " + str(GameState.Coin)
	crystal.text= "CRYSTAL: " + str(GameState.Crystal)
	kill.text= "KILLS: " + str(GameState.Kill)

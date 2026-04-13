extends Node

@onready var coin: Label = $COIN/COIN
@onready var crystal: Label = $CRYSTAL/CRYSTAL

func _process(delta):
	coin.text = "COINS: " + str(GameState.Coin)
	crystal.text= "CRYSTAL:" + str(GameState.Crystal)

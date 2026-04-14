class_name manager extends Node

var level = 1
var Coin = 0
var Crystal = 0
var enemy_kill_count = 0
var current_zone = "zone_1"
var player_position = Vector2.ZERO
var player:Player
var current_tilemap_bounds : Array[Vector2]
signal TileMapBoundsChanged(bounds:Array[Vector2])

func ChangeTilemapBounds(bounds:Array[Vector2]) -> void:
	current_tilemap_bounds=bounds
	TileMapBoundsChanged.emit(bounds)
	pass
	

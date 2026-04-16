class_name manager extends Node
var player:Player
var level = 1
var Coin = 6
var Crystal = 6
var enemy_kill_count = 0
var enemy_damage = 1
var damage = 1
var Kill = 0
var player_position = Vector2(558.0, 419.0)
var current_zone = "zone_1"
var current_tilemap_bounds : Array[Vector2]
signal TileMapBoundsChanged(bounds:Array[Vector2])

func ChangeTilemapBounds(bounds:Array[Vector2]) -> void:
	current_tilemap_bounds=bounds
	TileMapBoundsChanged.emit(bounds)
	pass
	
func _ready() -> void:

	pass

class_name manager extends Node
@onready var player: Player = $"../player"

var level = 1
var Coin = 0
var Crystal = 0
var enemy_kill_count = 0
var player_position = Vector2(568, 202)
var current_zone = "zone_1"
var current_tilemap_bounds : Array[Vector2]
signal TileMapBoundsChanged(bounds:Array[Vector2])

func ChangeTilemapBounds(bounds:Array[Vector2]) -> void:
	current_tilemap_bounds=bounds
	TileMapBoundsChanged.emit(bounds)
	pass
	
func _ready() -> void:

	pass

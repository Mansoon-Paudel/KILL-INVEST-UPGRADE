class_name manager extends Node
var speed = 150
var player: Player
var health = 5
var dashNum = 0
var dash_cooldown: float = 1.5
var Coin = 0
var Crystal = 0
var enemy_kill_count = 0
var enemy_damage = 1
var damage = 1
var Kill = 6
var player_position = Vector2(558.0, 419.0)
var current_zone = "zone_1"
var current_tilemap_bounds: Array[Vector2]
var tier: int = 1
const Dash_Speed = 450
signal TileMapBoundsChanged(bounds: Array[Vector2])
const TIER_SPRITES = [
	preload("res://SCENE/Player/Tier_1.tres"),
	preload("res://SCENE/Player/Tier_2.tres"),
	preload("res://SCENE/Player/Tier_3.tres")
]
const TIER_STATS = {
	1: {"speed": 30, "damage": 0, "health": 3},
	2: {"speed": 30, "damage": 2, "health": 3},
	3: {"speed": 70, "damage": 3, "health": 5},
}

func get_stat(stat: String):
	return TIER_STATS[tier][stat]

func upgrade_tier() -> void:
	if tier < 4:
		tier += 1
		speed = speed+get_stat("speed")
		health = health+get_stat("health")
		damage = damage+get_stat("damage")

func ChangeTilemapBounds(bounds: Array[Vector2]) -> void:
	current_tilemap_bounds = bounds

extends Node
class_name PlayerAbilities

const BOOMERANG = preload("res://05_2d_adventure_rpg_game/player/boomerang.tscn")

enum abilities {BOOMERANG}

var selected_ability = abilities.BOOMERANG
var player : Player
var boomerang_instance : Boomerang = null

func _ready() -> void:
	player = PlayerManager.player
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		if selected_ability == abilities.BOOMERANG:
			boomerang_ability()
		
	pass

func boomerang_ability() -> void:
	if is_instance_valid(boomerang_instance):
		return
	
	var _b = BOOMERANG.instantiate() as Boomerang
	player.add_sibling(_b)
	_b.global_position = player.global_position
	
	var throw_direction = player.direction
	if throw_direction == Vector2.ZERO:
		throw_direction = player.cardinal_direction
		
	_b.throw(throw_direction)
	
	boomerang_instance = _b
	pass

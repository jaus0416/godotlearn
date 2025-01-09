extends PlayerState
class_name PlayerStateStun

@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurt_box : HurtBox
var direction : Vector2

var next_state : PlayerState = null

@onready var idle : PlayerState = $"../Idle"

func init() -> void:
	player.player_damaged.connect(_player_damaged)
	pass

func enter() -> void:
	player.animation_player.animation_finished.connect(_animation_finished)
	
	#击退效果
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	player.set_direction()
	player.update_animation("stun")
	
	#invulnerable after stun
	player.make_invulerable(invulnerable_duration)
	player.effect_animation_player.play("damaged")
	pass
	
func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_animation_finished)
	pass

func process(_delta: float) -> PlayerState:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state
	
func physics_process(_delta: float) -> PlayerState:
	return null

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func _player_damaged(_hurt_box : HurtBox) -> void:
	hurt_box = _hurt_box
	state_machine.change_state(self)
	pass
	
func _animation_finished(_a : String) -> void:
	next_state = idle
	pass

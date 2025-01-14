extends EnemyState
class_name EnemyStateDestory

const PICKUP = preload("res://05_2d_adventure_rpg_game/items/item_pickup/item_pick_up.tscn")

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

@export_category("AI")

@export_category("Item Drops")
@export var drops : Array[DropData]

var _damage_position : Vector2
var _direction : Vector2

func init() -> void:
	enemy.enemy_destoryed.connect(_on_enemy_destroyed)
	pass

func enter() -> void:
	# 防止多次受伤
	enemy.invulnerable = true
	_direction = enemy.global_position.direction_to(_damage_position)
	
	enemy.set_direction(_direction)
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	#禁用伤害
	disable_hurt_box()
	
	#物品掉落
	drop_items()
	pass

func exit() -> void:
	pass

func process(_delta : float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

func physics_process(_delta : float) -> EnemyState:
	return null

func _on_enemy_destroyed(hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)

func _on_animation_finished(_a : String) -> void:
	enemy.queue_free()
	pass

func disable_hurt_box() -> void:
	var hurt_box : HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.monitoring = false
	pass

func drop_items() -> void:
	if drops.size() == 0:
		return
	for d in drops:
		if !d or !d.item:
			continue
		var drop_count : int = d.get_drop_count()
		for i in drop_count:
			var drop = PICKUP.instantiate() as ItemPickUp
			drop.item_data = d.item
			#enemy.get_parent().add_child(drop)
			enemy.get_parent().call_deferred("add_child", drop)
			drop.global_position = enemy.position
			# 随机掉落
			drop.velocity = enemy.velocity.rotated(randf_range(-1.5, 1.5)) * randf_range(0.9, 1.5)
	pass

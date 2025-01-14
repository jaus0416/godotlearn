extends PlayerState
class_name PlayerStateAttack

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range(1, 20, 0.5) var decelerate_speed : float = 5.0

@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : PlayerState = $"../Idle"
@onready var walk : PlayerState = $"../Walk"
@onready var attack_anim : AnimationPlayer = $"../../Sprite2D/AttackEffectedSprite/AnimationPlayer"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurt_box : HurtBox = %AttackHurtBox

func enter() -> void:
	# animation
	player.update_animation("attack")
	attack_anim.play("attack" + "_" + player.anim_diretion())
	animation_player.animation_finished.connect(end_attack)
	
	# audio
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	attacking = true
	# do hurt
	await get_tree().create_timer(0.075).timeout
	if attacking:
		hurt_box.monitoring = true
	pass
	
func exit() -> void:
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	hurt_box.monitoring = false
	pass

func process(_delta: float) -> PlayerState:
	player.velocity -= player.velocity * decelerate_speed * _delta
	if !attacking:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func physics_process(_delta: float) -> PlayerState:
	return null

func handle_input(_event: InputEvent) -> PlayerState:
	return null

func end_attack(_new_anim_name: String) -> void: 
	attacking = false
	pass

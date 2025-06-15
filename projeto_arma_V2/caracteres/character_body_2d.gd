extends CharacterBody2D

@export var attack_cooldown := 0.5
@export var attack_duration := 0.8  # duração da animação de ataque em segundos
var can_attack := true
var is_attacking := false
var attack_timer := 0.0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready():
	# não precisamos mais conectar o animation_finished
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and can_attack and not is_attacking:
		start_attack()

	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			end_attack()
	else:
		update_idle_run_animation()

func start_attack():
	can_attack = false
	is_attacking = true
	attack_timer = attack_duration
	$AnimatedSprite2D.play("attack")
	$AttackHitbox.monitoring = true

func end_attack():
	is_attacking = false
	$AttackHitbox.monitoring = false
	$AnimatedSprite2D.play("idle")
	
	# Inicia cooldown (usando await, pois estamos fora de sinais agora)
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func update_idle_run_animation():
	if is_on_floor():
		var direction := Input.get_axis("ui_left", "ui_right")
		

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

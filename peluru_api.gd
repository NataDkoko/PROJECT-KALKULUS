extends CharacterBody2D

@export var speed: float = 200.0
@onready var anim = $AnimatedSprite2D

var last_direction: Vector2 = Vector2.DOWN
var is_attacking = false

func _physics_process(delta):
	if is_attacking:
		return

	var direction = Vector2.ZERO

	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		last_direction = direction

		play_run_animation(direction)
	else:
		play_idle_animation()

	velocity = direction * speed
	move_and_slide()

# =========================
# INPUT
# =========================
func _input(event):
	if event.is_action_pressed("attack"):
		print("klik terdeteksi")

# =========================
# MELEE
# =========================
func melee():
	if is_attacking:
		return

	is_attacking = true

	play_melee_animation()

	# (opsional) aktifkan hitbox di sini kalau sudah pakai
	# $MeleeHitbox.monitoring = true

	await get_tree().create_timer(0.3).timeout

	# $MeleeHitbox.monitoring = false
	is_attacking = false

# =========================
# ANIMATION FUNCTIONS
# =========================

func play_run_animation(direction):
	if abs(direction.x) > abs(direction.y):
		anim.play("run_side")
		anim.flip_h = direction.x < 0
	else:
		if direction.y > 0:
			anim.play("run_down")
		else:
			anim.play("run_up")

func play_idle_animation():
	if abs(last_direction.x) > abs(last_direction.y):
		anim.play("idle_side")
		anim.flip_h = last_direction.x < 0
	else:
		if last_direction.y > 0:
			anim.play("idle_down")
		else:
			anim.play("idle_up")

func play_melee_animation():
	if abs(last_direction.x) > abs(last_direction.y):
		anim.play("melle_side")
		anim.flip_h = last_direction.x < 0
	else:
		if last_direction.y > 0:
			anim.play("melle_down")
		else:
			anim.play("melle_up")

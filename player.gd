extends CharacterBody2D

@export var speed: float = 200.0
@export var goal_path: NodePath

@onready var anim = $AnimatedSprite2D
@onready var line = $Line2D

var goal = null
var show_nav = false

var is_attacking = false
var last_direction = Vector2.DOWN

# =========================
# READY
# =========================
func _ready():
	goal = get_node_or_null(goal_path)
	line.visible = false

# =========================
# INPUT
# =========================
func _input(event):
	if event.is_action_pressed("navigate"):
		show_nav = !show_nav
		line.visible = show_nav

	if event.is_action_pressed("attack"):
		melee()

# =========================
# NAVIGASI (VECTOR LURUS)
# =========================
func _process(_delta):
	if not show_nav:
		return
	if goal == null:
		return

	var direction = goal.global_position - global_position

	line.points = [
		Vector2.ZERO,
		direction
	]

# =========================
# MOVEMENT
# =========================
func _physics_process(_delta):
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
# MELEE
# =========================
func melee():
	if is_attacking:
		return

	is_attacking = true
	play_melee_animation()

	await anim.animation_finished

	is_attacking = false

# =========================
# ANIMATION
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

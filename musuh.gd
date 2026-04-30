extends CharacterBody2D

@export var speed_jalan: float = 10.0
@export var speed: float = 120.0
@export var acceleration: float = 6.0
@export var detection_range: float = 300.0
@export var max_health: int = 100

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent = $NavigationAgent2D

var current_health: int
var player: Node2D
var agent: NavigationAgent2D

var is_dead: bool = false

var damage_ke_player: int = 1
var waktu_tunggu_serang: float = 0.0
var waktu_ganti_arah: float = 0.0


func _ready():
	current_health = max_health
	player = get_parent().get_node("Player")
	agent = nav_agent

	agent.path_desired_distance = 4.0
	agent.target_desired_distance = 2.0

	# 🔥 PENTING: paksa musuh masuk ke navmesh
	var map = get_world_2d().get_navigation_map()
	global_position = NavigationServer2D.map_get_closest_point(map, global_position)


func _physics_process(delta):
	if is_dead:
		return

	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)
	var direction = Vector2.ZERO

	# =========================
	# MODE KEJAR
	# =========================
	if distance <= detection_range:
		agent.target_position = player.global_position

		var next_pos = agent.get_next_path_position()

		# ✅ pakai navigation kalau valid
		if not agent.is_navigation_finished() and next_pos != Vector2.ZERO:
			direction = (next_pos - global_position).normalized()
		else:
			# 🔥 fallback langsung ke player
			direction = (player.global_position - global_position).normalized()

		var target_velocity = direction * speed
		velocity = velocity.lerp(target_velocity, acceleration * delta)

	# =========================
	# MODE WANDER
	# =========================
	else:
		waktu_ganti_arah -= delta

		if waktu_ganti_arah <= 0 or agent.is_navigation_finished():
			var random_offset = Vector2(
				randf_range(-150, 150),
				randf_range(-150, 150)
			)

			var titik_tujuan = global_position + random_offset
			var map = get_world_2d().get_navigation_map()
			var titik_valid = NavigationServer2D.map_get_closest_point(map, titik_tujuan)

			agent.target_position = titik_valid
			waktu_ganti_arah = randf_range(2.0, 4.0)

		var next_pos = agent.get_next_path_position()

		if not agent.is_navigation_finished() and next_pos != Vector2.ZERO:
			direction = (next_pos - global_position).normalized()
		else:
			# 🔥 fallback random biar gak diam
			direction = Vector2(
				randf_range(-1, 1),
				randf_range(-1, 1)
			).normalized()

		var target_velocity = direction * speed_jalan
		velocity = velocity.lerp(target_velocity, acceleration * delta)

	# 🔥 SUPER FAILSAFE (biar 100% gak diam)
	if direction == Vector2.ZERO:
		direction = (player.global_position - global_position).normalized()
		velocity = direction * speed

	move_and_slide()
	update_animation()

	# =========================
	# SERANG (TIDAK DIUBAH)
	# =========================
	if waktu_tunggu_serang > 0:
		waktu_tunggu_serang -= delta
	else:
		if has_node("Hitbox"):
			var target_di_hitbox = $Hitbox.get_overlapping_bodies()

			for target in target_di_hitbox:
				if target.is_in_group("player"):
					if target.has_method("terima_damage"):
						target.terima_damage(damage_ke_player)
						waktu_tunggu_serang = 1.0


# =========================
# DAMAGE SYSTEM
# =========================
func take_damage(amount: int):
	if is_dead:
		return

	current_health -= amount
	print("Musuh kena hit! Darah sisa: ", current_health)

	if current_health <= 0:
		die()


func die():
	if is_dead:
		return

	is_dead = true
	Global.score += 100
	print("Skor bertambah! Total: ", Global.score)

	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)

	sprite.play("mati")
	await sprite.animation_finished
	queue_free()


# =========================
# ANIMASI (TIDAK DIUBAH)
# =========================
func update_animation():
	if is_dead:
		return

	var speed_now = velocity.length()

	if speed_now > 5:
		if sprite.animation != "run":
			sprite.play("run")
	else:
		if sprite.animation != "diam":
			sprite.play("diam")

	if abs(velocity.x) > 1:
		sprite.flip_h = velocity.x < 0

	sprite.speed_scale = clamp(speed_now / speed, 0.5, 1.5)


func _on_hitbox_body_entered(body: Node2D) -> void:
	pass

func _on_hitbox_body_exited(body: Node2D) -> void:
	pass

extends CharacterBody2D

@export var speed: float = 120.0
@export var acceleration: float = 6.0
@export var detection_range: float = 300.0
@export var max_health: int = 100  # Darah maksimal musuh

var current_health: int
var player: Node2D
var agent: NavigationAgent2D
var can_see_player: bool = false
var is_dead: bool = false # Status apakah musuh masih hidup
var damage_ke_player: int = 1
var waktu_tunggu_serang: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	current_health = max_health # Set darah saat baru mulai
	player = get_parent().get_node("Player")
	agent = $NavigationAgent2D
	
	agent.path_desired_distance = 4.0
	agent.target_desired_distance = 2.0

func _physics_process(delta):
	# Kalau musuhnya udah mati, stop semua pergerakan dan kode di bawahnya
	if is_dead:
		return 

	if player and agent:
		check_visibility()

		if can_see_player:
			if agent.target_position.distance_to(player.global_position) > 5:
				agent.target_position = player.global_position

			var direction = Vector2.ZERO

			if not agent.is_navigation_finished():
				var next_pos = agent.get_next_path_position()
				direction = (next_pos - global_position).normalized()
			else:
				direction = (player.global_position - global_position).normalized()

			var target_velocity = direction * speed
			velocity = velocity.lerp(target_velocity, acceleration * delta)

		else:
			velocity = velocity.lerp(Vector2.ZERO, acceleration * delta)

		move_and_slide()
		update_animation()
	if waktu_tunggu_serang > 0:
		waktu_tunggu_serang -= delta # Kurangi waktu tunggu tiap detik
	else:
		# Pastikan node Hitbox ada agar tidak error
		if has_node("Hitbox"): 
			var target_di_hitbox = $Hitbox.get_overlapping_bodies() 
			for target in target_di_hitbox:
				if target.is_in_group("player"):
					if target.has_method("terima_damage"):
						target.terima_damage(damage_ke_player)
						waktu_tunggu_serang = 1.0 # Gigit lagi setelah 1 detik
						
func check_visibility():
	var dist = global_position.distance_to(player.global_position)
	
	if dist > detection_range:
		can_see_player = false
		return

	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [self.get_rid()]
	
	var result = space_state.intersect_ray(query)
	
	if result and result.collider == player:
		can_see_player = true
	else:
		can_see_player = false

# Fungsi untuk menerima damage dari peluru
func take_damage(amount: int):
	if is_dead: 
		return # Kalau udah mati, gak usah kena damage lagi

	current_health -= amount
	print("Musuh kena hit! Darah sisa: ", current_health) # Buat ngecek di output
	
	if current_health <= 0:
		die()

# Fungsi untuk proses mati
func die():
	if is_dead: return # Cek agar skor tidak nambah dua kali
	is_dead = true
	
	Global.score += 100
	print("Skor bertambah! Total: ", Global.score)
	
	velocity = Vector2.ZERO # Berhenti bergerak
	
	# Matikan tabrakan biar player gak nabrak "mayat" musuh
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Mainkan animasi mati
	sprite.play("mati") 
	
	# Tunggu sampai animasi mati selesai dimainkan, baru hapus musuh dari game
	await sprite.animation_finished
	queue_free() 

func update_animation():
	if is_dead:
		return # Jangan update animasi lari/diam kalau lagi proses mati

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
	pass # Replace with function body.
	

func _on_hitbox_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

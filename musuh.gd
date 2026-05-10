extends CharacterBody2D

@export var speed_jalan: float = 10.0
@export var speed: float = 120.0
@export var acceleration: float = 6.0
@export var detection_range: float = 300.0
@export var max_health: int = 100  # Darah maksimal musuh
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent = $NavigationAgent2D
@onready var ray_cast_2d = $RayCast2D

var current_health: int
var player: Node2D
var agent: NavigationAgent2D
var can_see_player: bool = false
var is_dead: bool = false # Status apakah musuh masih hidup
var damage_ke_player: int = 1
var waktu_tunggu_serang: float = 0.0
var waktu_ganti_arah: float = 0.0


func _ready():
	current_health = max_health # Set darah saat baru mulai
	player = get_parent().get_node("Player")
	agent = $NavigationAgent2D
	
	agent.path_desired_distance = 4.0
	agent.target_desired_distance = 2.0

func _physics_process(delta):
	# Ambil player sekali di awal
	var player = get_tree().get_first_node_in_group("player")

	# Hapus musuh kalau player lari terlalu jauh
	if player:
		if global_position.distance_to(player.global_position) > 1200:
			queue_free()
			return # Langsung stop setelah queue_free

	# Stop semua pergerakan kalau musuh sudah mati
	if is_dead:
		return

	# --- LOGIKA PERGERAKAN ---
	if player and agent:
		if cek_liat_player():
			# --- MODE MENGEJAR (LARI) ---
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
			# --- MODE JALAN SANTAI (WANDER) ---
			waktu_ganti_arah -= delta

			if waktu_ganti_arah <= 0 or agent.is_navigation_finished():
				var random_offset = Vector2(randf_range(-150, 150), randf_range(-150, 150))
				var titik_tujuan = global_position + random_offset
				var map = get_world_2d().get_navigation_map()
				var titik_valid = NavigationServer2D.map_get_closest_point(map, titik_tujuan)
				agent.target_position = titik_valid
				waktu_ganti_arah = randf_range(2.0, 4.0)

			var direction = Vector2.ZERO
			if not agent.is_navigation_finished():
				var next_pos = agent.get_next_path_position()
				direction = (next_pos - global_position).normalized()

			var target_velocity = direction * speed_jalan
			velocity = velocity.lerp(target_velocity, acceleration * delta)

	elif agent:
		# Tidak ada player, wander saja
		waktu_ganti_arah -= delta

		if waktu_ganti_arah <= 0 or agent.is_navigation_finished():
			var random_offset = Vector2(randf_range(-150, 150), randf_range(-150, 150))
			var titik_tujuan = global_position + random_offset
			var map = get_world_2d().get_navigation_map()
			var titik_valid = NavigationServer2D.map_get_closest_point(map, titik_tujuan)
			agent.target_position = titik_valid
			waktu_ganti_arah = randf_range(2.0, 4.0)

		var direction = Vector2.ZERO
		if not agent.is_navigation_finished():
			var next_pos = agent.get_next_path_position()
			direction = (next_pos - global_position).normalized()

		var target_velocity = direction * speed_jalan
		velocity = velocity.lerp(target_velocity, acceleration * delta)

	move_and_slide()
	update_animation()

	# --- LOGIKA SERANGAN KETIKA DEKAT ---
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

# Fungsi untuk menerima damage dari peluru
func take_damage(amount: int):
	# 1. Cek paling awal: Kalau udah mati, gak usah diproses lagi
	if is_dead: 
		return 

	# 2. Langsung kurangi darah detik itu juga
	current_health -= amount
	print("Musuh kena hit! Darah sisa: ", current_health)
	
	# 3. Cek apakah pukulan ini bikin dia mati
	if current_health <= 0:
		die()
	else:
		# 4. JIKA BELUM MATI, baru jalankan animasi kelap-kelip merah
		for i in range(3):
			$AnimatedSprite2D.modulate = Color(0.8, 0.2, 0.2) 
			await get_tree().create_timer(0.1).timeout
			
			# Kembalikan ke warna asli
			$AnimatedSprite2D.modulate = Color(1, 1, 1)
			
			# Jika saat proses kedip ini tiba-tiba dia mati (kena hit beruntun), hentikan kedipnya
			if is_dead:
				break
				
			await get_tree().create_timer(0.1).timeout

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
	$SFXMati.play()
	
	await $SFXMati.finished
	
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

func cek_liat_player():
	if not ray_cast_2d:  # Kalau null, langsung return false
		return false
		
	var player = get_tree().get_first_node_in_group("player")
	if player:
		ray_cast_2d.target_position = to_local(player.global_position)
		ray_cast_2d.force_raycast_update()  # Paksa update raycast di frame yang sama
		if ray_cast_2d.is_colliding():
			var objek = ray_cast_2d.get_collider()
			if objek.is_in_group("player"):
				return true
	return false

func _on_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	

func _on_hitbox_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

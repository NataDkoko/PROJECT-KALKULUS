extends CharacterBody2D

@export var speed: float = 350.0
@export var peluru_scene: PackedScene = preload("res://peluru_api.tscn")
@onready var sprite_player = $AnimatedSprite2D
@onready var shadow = $BayanganSprite
@onready var muncung_senjata = $MuncungSenjata
@onready var anim = $AnimatedSprite2D
@onready var wadah_hati = get_tree().current_scene.find_child("WadahHati", true, false)

var max_darah: int = 3
var darah_sekarang: int = 3

var last_direction = Vector2.DOWN

func _ready():
	# 1. Bekukan pergerakan player
	set_physics_process(false)
	
	# 2. Atur player jadi transparan DULU sebelum portal mulai
	$AnimatedSprite2D.modulate.a = 0.0 # Alpha = 0 (tembus pandang)
	$Senjata.modulate.a = 0.0
	$AnimatedSprite2D.hide() 
	$Senjata.hide()
	$PortalEffect.modulate.a = 0.0
	$PortalEffect.show()
	
	# 3. Mainkan animasi portal
	var tween_portal_in = create_tween()
	tween_portal_in.tween_property($PortalEffect, "modulate:a", 1.0, 1.0)
	$PortalEffect.play("Portal")
	var tween_portal_out = create_tween()
	tween_portal_out.tween_property($PortalEffect, "modulate:a", 0.0, 0.5)
	await $PortalEffect.animation_finished 
	
	# 4. Sembunyikan portal, dan mulai munculkan player (masih transparan)
	$PortalEffect.hide() 
	$AnimatedSprite2D.show() 
	$Senjata.show()
	# 5. Buat efek Fade-In dengan Tween
	var tween = create_tween()
	# Maksud kode di bawah: Ubah properti "modulate:a" milik $AnimatedSprite2D menjadi 1.0 dalam waktu 0.5 detik
	tween.tween_property($AnimatedSprite2D, "modulate:a", 1.0, 0.5)
	var tween_senjata = create_tween()
	tween_senjata.tween_property($Senjata, "modulate:a", 1.0, 0.5)
	
	# Tunggu sampai efek fade-in selesai
	await tween.finished
	
	# 6. Izinkan player bergerak lagi
	set_physics_process(true)


# =========================
# MOVEMENT + ANIMASI
# =========================
func _physics_process(_delta):
	var direction = Vector2.ZERO

	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		last_direction = direction

		# PRIORITAS ARAH
		if abs(direction.x) > abs(direction.y):
			anim.play("run_side")
			anim.flip_h = direction.x < 0
		else:
			if direction.y > 0:
				anim.play("run_down")
			else:
				anim.play("run_up")
	else:
		# IDLE
		if abs(last_direction.x) > abs(last_direction.y):
			anim.play("idle_side")
			anim.flip_h = last_direction.x < 0
		else:
			if last_direction.y > 0:
				anim.play("idle_down")
			else:
				anim.play("idle_up")

	velocity = direction * speed
	move_and_slide()


# =========================
# DAMAGE SYSTEM
# =========================
func terima_damage(amount: int):
	for i in range(3):
		# 1. Ubah warna menjadi Merah Gelap (atau Hitam)
		# Color(R, G, B) -> 1 adalah full, 0 adalah gelap
		$AnimatedSprite2D.modulate = Color(0.8, 0.2, 0.2) 
		
		# Tunggu 0.1 detik
		await get_tree().create_timer(0.1).timeout
		
		# 2. Kembalikan ke warna asli (Putih Murni = warna normal gambar)
		$AnimatedSprite2D.modulate = Color(1, 1, 1)
		
		# Tunggu 0.1 detik lagi sebelum mengulang kelap-kelip
		await get_tree().create_timer(0.1).timeout
	var previous_darah = darah_sekarang
	darah_sekarang -= amount

	print("Darah Player: ", darah_sekarang)

	var heart_index_to_animate = previous_darah - 1
	animasi_hati_hilang(heart_index_to_animate)

	if darah_sekarang <= 0:
		mati()


func animasi_hati_hilang(index: int):
	if wadah_hati:
		var daftar_hati = wadah_hati.get_children()

		if index >= 0 and index < daftar_hati.size():
			var hati_node = daftar_hati[index]

			if hati_node.has_method("mainkan_animasi_kena_hit"):
				hati_node.mainkan_animasi_kena_hit()


func mati():
	print("Player Mati!")
	# 1. Muat (Load) scene Game Over ke dalam memori
	Transition.change_scene("res://GameOverScreen.tscn")
	var layar_game_over = load("res://GameOverScreen.tscn")
	var instance = layar_game_over.instantiate()
	
	get_tree().root.add_child(instance)
	

	# 3. Pause gamenya agar player dan musuh berhenti bergerak!
	get_tree().paused = true
func tembak():
	var peluru = peluru_scene.instantiate()

	peluru.global_position = muncung_senjata.global_position
	peluru.global_rotation = global_rotation 

	get_tree().current_scene.add_child(peluru)
	

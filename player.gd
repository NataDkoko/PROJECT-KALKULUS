extends CharacterBody2D

@export var speed: float = 350.0
@export var peluru_scene: PackedScene = preload("res://peluru_api.tscn")
@onready var muncung_senjata = $MuncungSenjata
@onready var anim = $AnimatedSprite2D
@onready var wadah_hati = get_tree().current_scene.find_child("WadahHati", true, false)

var max_darah: int = 3
var darah_sekarang: int = 3

func _physics_process(_delta):
	var direction = Vector2.ZERO

	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		anim.play("walk_right")
	else:
		anim.play("idle")

	# Flip kiri-kanan
	if direction.x != 0:
		anim.flip_h = direction.x < 0
		
		
	velocity = direction * speed
	move_and_slide()

func terima_damage(amount: int):
	# Simpan darah sebelumnya untuk tahu hati indeks mana yang harus dianimasi
	var previous_darah = darah_sekarang
	darah_sekarang -= amount
	print("Darah Player: ", darah_sekarang)
	
	# --- LOGIKA ANIMASI HATI BARU ---
	# Hitung indeks hati yang baru saja hilang
	# Contoh: darah 3 jadi 2 -> Previous_darah (3) - 1 = Indeks 2 (Hati ke-3)
	var heart_index_to_animate = previous_darah - 1
	animasi_hati_hilang(heart_index_to_animate)
	
	if darah_sekarang <= 0:
		mati()
func animasi_hati_hilang(index: int):
	if wadah_hati:
		var daftar_hati = wadah_hati.get_children()
		
		# Cek apakah indeks-nya valid dan node-nya ada
		if index >= 0 and index < daftar_hati.size():
			var hati_node = daftar_hati[index]
			# Panggil fungsi animasi di script res://hati_ui.gd tadi
			if hati_node.has_method("mainkan_animasi_kena_hit"):
				hati_node.mainkan_animasi_kena_hit()
				
func mati():
	print("Player Mati!")
	get_tree().reload_current_scene() # Game mulai ulang kalau mati
	
	
func tembak():
	var peluru = peluru_scene.instantiate()
	# Taruh peluru di posisi muncung senjata
	peluru.global_position = muncung_senjata.global_position
	# Samakan rotasi peluru dengan rotasi player agar arahnya benar
	peluru.global_rotation = global_rotation 
	# Masukkan peluru ke dalam scene utama agar tidak ikut gerak saat player gerak
	get_tree().current_scene.add_child(peluru)

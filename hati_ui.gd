extends Control

var is_empty: bool = false
@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.stop()
	sprite.frame = 0
	# Hubungkan signal agar kita tahu kapan animasi selesai
	sprite.animation_finished.connect(_on_animation_finished)

func mainkan_animasi_kena_hit():
	if is_empty: return
	is_empty = true
	sprite.play("hit_anim")

func _on_animation_finished():
	# Jika animasi 'hit_anim' selesai, sembunyikan seluruh node hati ini
	if sprite.animation == "hit_anim":
		visible = false

func mainkan_animasi_pulih():
	# 1. Tandai bahwa hati ini tidak kosong lagi
	is_empty = false
	
	# 2. Munculkan kembali node ini ke layar
	visible = true
	
	# 3. Kembalikan ke gambar hati penuh (frame 0 dari hit_anim)
	sprite.animation = "hit_anim"
	sprite.frame = 0
	sprite.stop() # Hentikan animasi agar tidak jalan ke frame retak
	
	# 4. Efek Blink (Kelap-kelip)
	for i in range(3): # Berkedip 3 kali
		# Ubah warna menjadi agak transparan (Alpha = 0.3)
		sprite.modulate = Color(1, 1, 1, 0.3) 
		await get_tree().create_timer(0.1).timeout
		
		# Kembalikan warna ke normal (Alpha = 1.0)
		sprite.modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(0.1).timeout

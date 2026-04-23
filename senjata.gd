extends Node2D

# Variabel untuk menampung file peluru
@export var peluru_scene: PackedScene 

func _process(_delta):
	# 1. Membuat senjata selalu membidik ke arah kursor mouse
	look_at(get_global_mouse_position())
	
	# 2. Jika klik kiri ditekan, jalankan fungsi tembak()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		tembak()

func tembak():
	# SEMUA yang ada di bawah ini hanya jalan jika Timer sudah berhenti (1 detik sekali)
	if $TimerTembak.is_stopped():
		if peluru_scene != null:
			# 1. Logika Munculkan Peluru
			var peluru = peluru_scene.instantiate()
			peluru.global_position = $TitikTembak.global_position
			peluru.rotation = global_rotation
			get_tree().current_scene.add_child(peluru)
			
			# 2. Logika Suara (WAJIB DI SINI)
			# Baris ini tidak akan pernah jalan sebelum 1 detik berlalu
			$TembakSFX.pitch_scale = randf_range(0.9, 1.1)
			$TembakSFX.play()
			
			# 3. Mulai ulang Timer
			$TimerTembak.start()
		else:
			print("File peluru belum dimasukkan!")
# ... kodinganmu untuk memunculkan peluru ...
	var peluru = peluru_scene.instantiate()
	get_tree().root.add_child(peluru)
	
	# TAMBAHKAN BARIS INI:
	$TembakSFX.pitch_scale = randf_range(0.9, 1.1)
	

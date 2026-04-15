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
	# 3. Cek apakah pistol sudah bisa menembak (cooldown selesai)
	if $TimerTembak.is_stopped():
		
		# 4. Memastikan file peluru sudah kamu masukkan di Inspector
		if peluru_scene != null:
			var peluru = peluru_scene.instantiate()
			
			# PENTING: Posisi muncul peluru diletakkan di ujung laras, BUKAN di mouse
			peluru.global_position = $TitikTembak.global_position
			peluru.rotation = global_rotation
			
			# Lepaskan peluru ke dalam dunia game
			get_tree().current_scene.add_child(peluru)
			
			# Mulai ulang timer agar ada jeda sebelum peluru berikutnya
			$TimerTembak.start()
		else:
			print("PERINGATAN: Kamu belum memasukkan file peluru_api.tscn ke kolom Inspector Senjata!")	

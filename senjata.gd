extends Node2D

@export var peluru_scene: PackedScene 

var max_peluru: int = 5
var peluru_sekarang: int = 5
var timer_isi_ulang: float = 0.0

# Baris ini untuk mencari node bernama "Ammo" di dalam folder UI
@onready var ammo_label = get_tree().current_scene.find_child("AmmoLabel", true, false)
@onready var wadah_peluru = get_tree().current_scene.find_child("WadahPeluru", true, false)

func _ready():
	# Cek di awal apakah node Ammo ditemukan
	if ammo_label == null:
		print("PERINGATAN: Node 'Ammo' tidak ditemukan! Pastikan namanya sama persis di Scene Tree.")

func _process(delta):
	look_at(get_global_mouse_position())
	
	if wadah_peluru:
		var daftar_ikon_peluru = wadah_peluru.get_children() # Ambil ke-5 gambar peluru
		
		# Looping untuk mengecek setiap gambar peluru
		for i in range(daftar_ikon_peluru.size()):
			if i < peluru_sekarang:
				daftar_ikon_peluru[i].visible = true  # Munculkan gambar
			else:
				daftar_ikon_peluru[i].visible = false # Sembunyikan gambar
	
	# --- BAGIAN UPDATE UI ---
	if ammo_label:
		ammo_label.text = "Peluru: " + str(peluru_sekarang) + " / " + str(max_peluru)
	
	# Logika Pengisian Peluru
	if peluru_sekarang < max_peluru:
		timer_isi_ulang += delta
		if timer_isi_ulang >= 2.0:
			peluru_sekarang += 1
			timer_isi_ulang = 0.0

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		tembak()

func tembak():
	if $TimerTembak.is_stopped() and peluru_sekarang > 0:
		if peluru_scene != null:
			peluru_sekarang -= 1 # Mengurangi jumlah peluru
			
			var peluru = peluru_scene.instantiate()
			peluru.global_position = $TitikTembak.global_position
			peluru.rotation = global_rotation
			get_tree().current_scene.add_child(peluru)
			
			$TembakSFX.pitch_scale = randf_range(0.9, 1.1)
			$TembakSFX.play()
			$TimerTembak.start()

extends Node2D
# Load scene musuh agar bisa dipanggil
@export var musuh_scene: PackedScene = preload("res://musuh.tscn")
@onready var semua_titik_spawn = $SpawnPoints.get_children()
@export var spawn_radius_max: float = 700.0 # Jarak terjauh dari player
@export var spawn_radius_min: float = 250.0 # Jarak terdekat (biar gak muncul di depan muka)
@export var limit_musuh: int = 20           # Batas total musuh di map

var jumlah_titik_aktif: int = 5 # Mulai dengan 5 titik sekaligus
var interval_tambah_musuh: float = 15.0 # Setiap 15 detik, jumlah spawn point bertambah
var timer_internal: float = 0.0

func _process(delta):
	# Logika untuk meningkatkan jumlah titik spawn seiring waktu
	timer_internal += delta
	if timer_internal >= interval_tambah_musuh:
		# Tambah 1 titik spawn setiap interval, selama belum melebihi total marker yang ada
		if jumlah_titik_aktif < semua_titik_spawn.size():
			jumlah_titik_aktif += 1
			print("Kesulitan meningkat! Sekarang muncul di ", jumlah_titik_aktif, " titik sekaligus.")
		timer_internal = 0.0


# Fungsi ini akan dipanggil otomatis setiap kali timer habis (misal tiap 3 detik)
func _on_spawn_timer_timeout():
	# 1. Cek total limit musuh di seluruh map
	var semua_musuh = get_tree().get_nodes_in_group("musuh")
	if semua_musuh.size() >= limit_musuh:
		return

	# 2. Cari player
	var player = get_tree().get_first_node_in_group("player")
	if not player: return
	
	# 3. Filter titik dengan dua syarat: RADIUS dan KEPADATAN
	var titik_valid = []
	for titik in semua_titik_spawn:
		var jarak_ke_player = player.global_position.distance_to(titik.global_position)
		
		if jarak_ke_player <= spawn_radius_max and jarak_ke_player >= spawn_radius_min:
			
			var jumlah_numpuk = 0
			for m in semua_musuh:
				# Jarak 60 pixel dianggap "numpuk" di titik yang sama
				if m.global_position.distance_to(titik.global_position) < 60:
					jumlah_numpuk += 1
			
			# SEKARANG KITA GANTI KE < 2
			# Jika sudah ada 2 musuh di titik ini, maka jangan tambahkan lagi
			if jumlah_numpuk < 2:
				titik_valid.append(titik)
	
	# 4. Eksekusi Spawn seperti biasa
	if titik_valid.size() > 0:
		titik_valid.shuffle() 
		var jumlah_muncul = min(jumlah_titik_aktif, titik_valid.size())
		
		for i in range(jumlah_muncul):
			var titik_terpilih = titik_valid[i]
			var musuh_baru = musuh_scene.instantiate()
			
			# Tetap gunakan offset kecil agar 2 musuh tersebut tidak nempel persis
			var offset_acak = Vector2(randf_range(-30, 30), randf_range(-30, 30))
			musuh_baru.global_position = titik_terpilih.global_position + offset_acak
			
			musuh_baru.add_to_group("musuh")
			add_child(musuh_baru)

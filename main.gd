extends Node2D
# Load scene musuh agar bisa dipanggil
@export var musuh_scene: PackedScene = preload("res://musuh.tscn")

# Ambil semua titik spawn yang sudah kita buat
@onready var semua_titik_spawn = $SpawnPoints.get_children()

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
	if semua_titik_spawn.size() > 0:
		# 1. Duplikat daftar titik agar kita bisa mengacaknya tanpa merusak daftar asli
		var daftar_acak = semua_titik_spawn.duplicate()
		daftar_acak.shuffle() # Mengacak urutan titik secara total
		
		# 2. Tentukan berapa banyak musuh yang akan dimunculkan
		# Kita batasi agar tidak melebihi jumlah marker yang kamu buat di editor
		var jumlah_muncul = min(jumlah_titik_aktif, daftar_acak.size())
		
		# 3. Looping untuk memunculkan musuh di titik-titik hasil undian
		for i in range(jumlah_muncul):
			var titik_terpilih = daftar_acak[i]
			var musuh_baru = musuh_scene.instantiate()
			# Memberikan pergeseran acak antara -20 sampai 20 piksel (sesuaikan dengan ukuran musuhmu)
			var offset_acak = Vector2(randf_range(-20, 20), randf_range(-20, 20))
			# Posisikan musuh di titik terpilih ditambah pergeseran acaknya
			musuh_baru.global_position = titik_terpilih.global_position + offset_acak
			# -------------------------------
			
			add_child(musuh_baru)

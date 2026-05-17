extends Area2D

@export var heal_amount = 1 # Berapa banyak darah yang ditambah

func _ready():
	# 1. Animasi Loncat Saat Muncul
	var tween_loncat = create_tween()
	var posisi_awal = position
	
	# Loncat ke atas (Y minus) dengan cepat (0.2 detik)
	tween_loncat.tween_property(self, "position:y", posisi_awal.y - 30, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Jatuh ke tanah lagi dengan efek memantul
	tween_loncat.tween_property(self, "position:y", posisi_awal.y, 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	# 2. Setelah jatuh, jalankan animasi mengambang
	tween_loncat.finished.connect(mulai_mengambang)

func mulai_mengambang():
	var tween_ambang = create_tween().set_loops() # Animasi berulang terus
	
	# Kita gerakkan Sprite-nya (bukan Area2D-nya) agar hitbox tidak ikut geser
	tween_ambang.tween_property($Sprite2D, "position:y", -5.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_ambang.tween_property($Sprite2D, "position:y", 0.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# 3. Fungsi saat hati disentuh
func _on_body_entered(body):
	# Pastikan yang menyentuh adalah Player
	if body.name == "Player":
		# Pastikan Player punya fungsi tambah_darah di script-nya
		if body.has_method("tambah_darah"):
			body.tambah_darah(heal_amount)
			queue_free() # Hilangkan hati dari map

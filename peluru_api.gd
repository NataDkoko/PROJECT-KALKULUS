extends Area2D

# Kecepatan lari peluru
@export var speed: float = 800.0 
# Tambahan: Besar damage yang diberikan peluru
@export var damage: int = 50

func _process(delta):
	# Mengambil arah depan peluru
	var arah = Vector2.RIGHT.rotated(rotation)
	
	# Bergerak maju
	position += arah * speed * delta

# Menghapus peluru saat keluar layar
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

# ---------------------------------------------------------
# BARU: Fungsi ketika peluru menabrak sesuatu (musuh)
# ---------------------------------------------------------
func _on_body_entered(body):
	## Cek apakah yang ditabrak punya fungsi 'take_damage' (seperti musuh)
	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free() # Hapus peluru setelah kena musuh
	elif not body.is_in_group("player"):
		queue_free() # Hapus peluru kalau kena tembok (asal bukan player)

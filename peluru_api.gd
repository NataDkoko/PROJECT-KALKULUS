extends Area2D

# Kecepatan lari peluru (huruf kecil semua)
@export var speed: float = 800.0 

func _process(delta):
	# Mengambil arah depan peluru
	var arah = Vector2.RIGHT.rotated(rotation)
	
	# PENTING: Perhatikan tanda += dan perkalian dengan delta
	position += arah * speed * delta

# Fungsi untuk menghapus peluru saat keluar layar (pastikan sinyalnya sudah terhubung)
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

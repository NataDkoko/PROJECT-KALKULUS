extends Area2D

# Kecepatan lari peluru
@export var speed: float = 800.0 
# Tambahan: Besar damage yang diberikan peluru
@export var damage: int = 20 

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
	# Mengecek apakah objek yang ditabrak memiliki fungsi 'terima_damage'
	if body.has_method("terima_damage"):
		# Memanggil fungsi di script musuh dan mengirimkan nilai damage
		body.terima_damage(damage)
		
		# Hapus peluru setelah berhasil mengenai musuh
		queue_free()

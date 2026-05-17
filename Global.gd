extends Node

var score: int = 0
func restart_game():
	# 1. Reset skor global menjadi 0 kembali
	Global.score = 0 
	
	# 2. Baru jalankan perintah reload scene yang sudah kamu buat
	get_tree().reload_current_scene()

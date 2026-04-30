extends Control # Atau CanvasLayer, sesuaikan dengan node utama kamu

func _on_retry_butt_pressed():
	# Perintah untuk mengulang scene game kamu
	# Ganti "res://GameScene.tscn" dengan nama file scene main game kamu
	get_tree().change_scene_to_file("res://GameScene.tscn")

func _on_menu_butt_pressed():
	# Perintah untuk balik ke Main Menu
	# Ganti "res://MainMenu.tscn" dengan nama file scene menu utama kamu
	get_tree().change_scene_to_file("res://MainMenu.tscn")

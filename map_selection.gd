extends Control

func _on_map_1_button_pressed():
	# Ganti dengan nama file map labirin lama kamu
	get_tree().change_scene_to_file("res://main.tscn")

func _on_map_2_button_pressed():
	# Ganti dengan nama file map baru dari temanmu
	get_tree().change_scene_to_file("res://map_2.tscn") 

func _on_back_button_pressed():
	# Kembali ke Main Menu
	get_tree().change_scene_to_file("res://mainmenu.tscn")

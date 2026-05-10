extends Control

func _on_map_1_button_pressed():
	# Ganti dengan nama file map labirin lama kamu
	Transition.change_scene("res://main.tscn")

func _on_map_2_button_pressed():
	# Ganti dengan nama file map baru dari temanmu
	Transition.change_scene("res://map_2.tscn")

func _on_back_button_pressed():
	# Kembali ke Main Menu
	Transition.change_scene("res://mainmenu.tscn")

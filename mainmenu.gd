extends Control

func _on_start_button_pressed():
	# Revisi: Pindah ke scene main.tscn
	get_tree().change_scene_to_file("res://map_selection.tscn")

func _on_credit_button_pressed():
	# Untuk sementara kita cetak pesan dulu di konsol
	print("Dibuat oleh: [Nama Kamu] & [Nama Temanmu]")

func _on_exit_button_pressed():
	# Fungsi untuk menutup game
	get_tree().quit()

extends Control

func _ready():
	$AnimationPlayer.play("animasi_tittle")

func _on_start_button_pressed():
	# Revisi: Pindah ke scene main.tscn
	$StartButton/sfxklik.play()
	await get_tree().create_timer(0.2).timeout
	
	Transition.change_scene("res://map_selection.tscn")

func _on_credit_button_pressed():
	# Untuk sementara kita cetak pesan dulu di konsol
	await get_tree().create_timer(0.2).timeout
	
	Transition.change_scene("res://credits.tscn")


func _on_exit_button_pressed():
	# Fungsi untuk menutup game
	get_tree().quit()

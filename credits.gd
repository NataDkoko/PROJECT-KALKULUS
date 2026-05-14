extends Control

func _ready():
	# Jalankan animasi saat scene dibuka
	$AnimationPlayer.play("run_credits")
	
	# Hubungkan signal animation_finished ke fungsi di bawah
	$AnimationPlayer.animation_finished.connect(_on_credits_finished)

func _on_credits_finished(_anim_name):
	# Gunakan transisi keren kita untuk balik ke Main Menu
	Transition.change_scene("res://mainmenu.tscn")

# Opsi tambahan: Jika pemain klik atau tekan tombol, langsung skip ke menu
func _input(event):
	if event.is_pressed():
		Transition.change_scene("res://mainmenu.tscn")

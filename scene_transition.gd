extends CanvasLayer

func change_scene(target_path: String):
	# 1. Mainkan animasi fade ke hitam
	$AnimationPlayer.play("dissolve")
	
	# Tunggu sampai animasinya selesai
	await $AnimationPlayer.animation_finished
	
	# 2. Pindah scene di latar belakang saat layar sedang gelap
	get_tree().change_scene_to_file(target_path)
	
	# 3. Mainkan animasi mundur (dari hitam kembali ke transparan)
	$AnimationPlayer.play_backwards("dissolve")

extends Control

func _on_retry_butt_pressed() -> void:
	## Cairkan game dari pause
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://main.tscn")
	queue_free()
func _on_menu_butt_pressed() -> void:
	# Cairkan game dari pause
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://mainmenu.tscn")
	queue_free()

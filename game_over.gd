extends Control


# Called when the node enters the scene tree for the first time.
func _on_tryagain_pressed() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://main.tscn")
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_mainmenu_pressed() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://mainmenu.tscn")
	queue_free()
	
func _ready():
	$ScoreLabel.text = "Score     :     " + str(Global.score)

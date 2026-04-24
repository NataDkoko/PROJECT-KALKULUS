extends Area2D

func _on_goal_body_entered(body):
	get_tree().paused = true

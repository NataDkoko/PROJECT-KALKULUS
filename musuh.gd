extends CharacterBody2D

@export var speed: float = 120.0

var player: Node2D
var agent: NavigationAgent2D

func _ready():
	player = get_parent().get_node("Player")
	agent = $NavigationAgent2D

func _physics_process(delta):
	if player and agent:
		# 🎯 update target tiap frame
		agent.target_position = player.global_position

		# ambil titik jalur berikutnya
		var next_pos = agent.get_next_path_position()

		# arah ke titik itu
		var direction = (next_pos - global_position).normalized()

		velocity = direction * speed

	move_and_slide()

extends CharacterBody2D

@export var speed: float = 350.0
@onready var anim = $AnimatedSprite2D

func _physics_process(_delta):
	var direction = Vector2.ZERO

	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		anim.play("walk_right")
	else:
		anim.play("idle")

	# Flip kiri-kanan
	if direction.x != 0:
		anim.flip_h = direction.x < 0
		
		

	velocity = direction * speed
	move_and_slide()

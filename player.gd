extends CharacterBody2D

@export var speed: float = 350.0
@export var peluru_scene: PackedScene = preload("res://peluru_api.tscn")

@onready var muncung_senjata = $MuncungSenjata
@onready var anim = $AnimatedSprite2D
@onready var wadah_hati = get_tree().current_scene.find_child("WadahHati", true, false)

var max_darah: int = 3
var darah_sekarang: int = 3

var last_direction = Vector2.DOWN


# =========================
# MOVEMENT + ANIMASI
# =========================
func _physics_process(_delta):
	var direction = Vector2.ZERO

	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		last_direction = direction

		# PRIORITAS ARAH
		if abs(direction.x) > abs(direction.y):
			anim.play("run_side")
			anim.flip_h = direction.x < 0
		else:
			if direction.y > 0:
				anim.play("run_down")
			else:
				anim.play("run_up")
	else:
		# IDLE
		if abs(last_direction.x) > abs(last_direction.y):
			anim.play("idle_side")
			anim.flip_h = last_direction.x < 0
		else:
			if last_direction.y > 0:
				anim.play("idle_down")
			else:
				anim.play("idle_up")

	velocity = direction * speed
	move_and_slide()


# =========================
# DAMAGE SYSTEM
# =========================
func terima_damage(amount: int):
	var previous_darah = darah_sekarang
	darah_sekarang -= amount

	print("Darah Player: ", darah_sekarang)

	var heart_index_to_animate = previous_darah - 1
	animasi_hati_hilang(heart_index_to_animate)

	if darah_sekarang <= 0:
		mati()


func animasi_hati_hilang(index: int):
	if wadah_hati:
		var daftar_hati = wadah_hati.get_children()

		if index >= 0 and index < daftar_hati.size():
			var hati_node = daftar_hati[index]

			if hati_node.has_method("mainkan_animasi_kena_hit"):
				hati_node.mainkan_animasi_kena_hit()


func mati():
	print("Player Mati!")
	get_tree().reload_current_scene()


# =========================
# TEMBAK
# =========================
func tembak():
	var peluru = peluru_scene.instantiate()

	peluru.global_position = muncung_senjata.global_position
	peluru.global_rotation = global_rotation 

	get_tree().current_scene.add_child(peluru)

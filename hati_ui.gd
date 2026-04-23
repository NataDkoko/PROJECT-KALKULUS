extends Control

var is_empty: bool = false
@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.stop()
	sprite.frame = 0
	# Hubungkan signal agar kita tahu kapan animasi selesai
	sprite.animation_finished.connect(_on_animation_finished)

func mainkan_animasi_kena_hit():
	if is_empty: return
	is_empty = true
	sprite.play("hit_anim")

func _on_animation_finished():
	# Jika animasi 'hit_anim' selesai, sembunyikan seluruh node hati ini
	if sprite.animation == "hit_anim":
		visible = false

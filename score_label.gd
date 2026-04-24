extends Label

func _process(_delta):
	# Mengubah angka score menjadi teks
	text = "Score: " + str(Global.score)

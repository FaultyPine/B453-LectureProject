extends Node


enum ColorIdx {
	GREEN,
	YELLOW,
	BLUE,
	RED,
}

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
func _ready():
	pass

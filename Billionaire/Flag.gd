extends Node2D

var FlagColorSprites = [
	"res://Kenney/platformer-art-complete-pack-0/Base pack/Items/flagGreen.png",
	"res://Kenney/platformer-art-complete-pack-0/Base pack/Items/flagYellow.png",
	"res://Kenney/platformer-art-complete-pack-0/Base pack/Items/flagBlue.png",
	"res://Kenney/platformer-art-complete-pack-0/Base pack/Items/flagRed.png",
];
export var color = 0
func GetFlagSprite(color):
	return load(FlagColorSprites[color])

var is_clicked = false

func FlagClicked():
	is_clicked = true
func FlagReleased(mouse_pos: Vector2):
	self.global_position = mouse_pos
	is_clicked = false

func _process(delta):
	update() # forces _draw to be called
	
func _draw():
	if is_clicked:
		draw_line(self.position - self.global_position, get_global_mouse_position() - self.position, Color.white)

func _ready():
	pass

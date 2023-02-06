extends Node2D

onready var Body2D = $Body2D

var BillionColorSprites = [
	"res://Kenney/uipack_fixed/PNG/green_circle.png",
	"res://Kenney/uipack_fixed/PNG/yellow_circle.png",
	"res://Kenney/uipack_fixed/PNG/blue_circle.png",
	"res://Kenney/uipack_fixed/PNG/red_circle.png",
];
func GetBillionSprite(colorIdx):
	return BillionColorSprites[colorIdx];

func SetColor(colorIdx):
	$Sprite.texture = load(GetBillionSprite(colorIdx))

func _ready():
	pass



func _on_Billion_body_entered(body):
	print("OVERLAPPING BODY")
	var dir: Vector2 = (body.position - position)
	#Body2D.apply_central_impulse(dir)

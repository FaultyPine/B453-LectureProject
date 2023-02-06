extends Node2D

onready var Billion = preload("res://Billion.tscn")


var baseColor = Global.ColorIdx.BlUE
export var SpawnRadius: float

func _ready():
	pass



func SpawnBillionAtPosition(pos: Vector2):
	var billion = Billion.instance()
	billion.SetColor(baseColor)
	billion.get_node(".").position = pos
	self.add_child(billion)

func SpawnBillion():
	var spawn_position = Vector2(0,0)
	spawn_position.x = rand_range(-SpawnRadius, SpawnRadius)
	spawn_position.y = rand_range(-SpawnRadius, SpawnRadius)	
	SpawnBillionAtPosition(spawn_position)

func _on_Timer_timeout():
	SpawnBillion()
	$Timer.start()

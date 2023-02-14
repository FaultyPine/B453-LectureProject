extends Node2D

var baseColor = Global.ColorIdx.BLUE
onready var BaseSpawnNode = $Billions
export var SpawnRadius: float
const MaxBillions: int = 10
onready var Billion = preload("res://Billion.tscn")


func _ready():
	$Timer.start()

func SpawnBillionAtPosition(pos: Vector2):
	var billion = Billion.instance()
	billion.SetColor(baseColor)
	billion.get_node(".").position = pos
	BaseSpawnNode.add_child(billion)

func SpawnBillion():
	var spawn_position = Vector2(0,0)
	spawn_position.x = rand_range(-SpawnRadius, SpawnRadius)
	spawn_position.y = rand_range(-SpawnRadius, SpawnRadius)	
	SpawnBillionAtPosition(spawn_position)

func _on_Timer_timeout():
	if len(BaseSpawnNode.get_children()) < MaxBillions:
		SpawnBillion()
		$Timer.start()

extends Node2D

var baseColor = Global.ColorIdx.BLUE
onready var BaseSpawnNode = $Billions
export var SpawnRadius: float
const MaxBillions: int = 1
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
	var random_vector = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	random_vector = random_vector.normalized()
	spawn_position = random_vector * SpawnRadius
	SpawnBillionAtPosition(spawn_position)

func _on_Timer_timeout():
	if len(BaseSpawnNode.get_children()) < MaxBillions:
		SpawnBillion()
		$Timer.start()

extends Node2D

onready var BaseScene = preload("res://Base.tscn")
onready var tileMap = $"../TileMap"
	
export var NumBasesToSpawn: int
export var NonWallTileMapId: int

var BaseColorSprites = [
	"res://Kenney/spaceshooter/PNG/ufoGreen.png",
	"res://Kenney/spaceshooter/PNG/ufoYellow.png",
	"res://Kenney/spaceshooter/PNG/ufoBlue.png",
	"res://Kenney/spaceshooter/PNG/ufoRed.png",
];
func GetBaseSprite(colorIdx):
	return BaseColorSprites[colorIdx];


func SpawnBaseAtPosition(pos: Vector2, colorIdx):
	var base = BaseScene.instance()
	var rootBaseNode = base.get_node(".")
	rootBaseNode.get_node("Sprite").texture = load(GetBaseSprite(colorIdx))
	rootBaseNode.baseColor = colorIdx
	rootBaseNode.position = pos
	add_child(base)


func _ready():
	# select random tilemap tile and spawn base there
	var tileMapOpenCells = tileMap.get_used_cells_by_id(NonWallTileMapId)
	for i in range(NumBasesToSpawn):
		var randCellIdx = rand_range(0, tileMapOpenCells.size())
		var randCell: Vector2 = tileMapOpenCells[randCellIdx]
		var spawn_position = tileMap.map_to_world(randCell)
		print("Spawning base at tilemap tile: " + str(randCell) + " worldpos = " + str(spawn_position))
		SpawnBaseAtPosition(spawn_position, i)
	

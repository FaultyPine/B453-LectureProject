extends Node2D

onready var BaseScene = preload("res://Base.tscn")
onready var tileMap = $"../TileMap"
onready var FlagScene = preload("res://Flag.tscn")
var numFlagsPlaced = [0,0,0,0]
onready var FlagsParent = $Flags
export var NumBasesToSpawn: int
export var NonWallTileMapId: int
var MaxFlagsPerBase: int = 2

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



func SpawnFlagAtPos(pos: Vector2, color):
	if (numFlagsPlaced[color] >= 2): return
	numFlagsPlaced[color] += 1
	var flag = FlagScene.instance()
	flag.get_node("./Sprite").texture = flag.GetFlagSprite(color)
	flag.position = pos
	FlagsParent.add_child(flag)

func FindClosestFlag(mouse_pos: Vector2):
	var closest = null
	for child in FlagsParent.get_children():
		if closest == null or child.position.distance_to(mouse_pos) < closest.position.distance_to(mouse_pos):
			closest = child
	return closest

var CurrentClickedFlag = null
func _input(event):
	var mouse_pos = get_global_mouse_position()
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_1 and not event.echo:
			SpawnFlagAtPos(mouse_pos, Global.ColorIdx.GREEN)
		if event.scancode == KEY_2 and not event.echo:
			SpawnFlagAtPos(mouse_pos, Global.ColorIdx.YELLOW)
	elif event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		CurrentClickedFlag = FindClosestFlag(mouse_pos)
		if CurrentClickedFlag:
			CurrentClickedFlag.FlagClicked()
	elif event is InputEventMouseButton and not event.is_pressed() and event.button_index == BUTTON_LEFT:
		if CurrentClickedFlag:
			CurrentClickedFlag.FlagReleased(mouse_pos)
			CurrentClickedFlag = null
	

func _ready():
	# select random tilemap tile and spawn base there
	var tileMapOpenCells = tileMap.get_used_cells_by_id(NonWallTileMapId)
	for i in range(NumBasesToSpawn):
		var randCellIdx = rand_range(0, tileMapOpenCells.size())
		var randCell: Vector2 = tileMapOpenCells[randCellIdx]
		var spawn_position = tileMap.map_to_world(randCell)
		print("Spawning base at tilemap tile: " + str(randCell) + " worldpos = " + str(spawn_position))
		SpawnBaseAtPosition(spawn_position, i)
	

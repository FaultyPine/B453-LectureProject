extends RigidBody2D

var BillionColorSprites = [
	"res://Kenney/uipack_fixed/PNG/green_circle.png",
	"res://Kenney/uipack_fixed/PNG/yellow_circle.png",
	"res://Kenney/uipack_fixed/PNG/blue_circle.png",
	"res://Kenney/uipack_fixed/PNG/red_circle.png",
];
func GetBillionSprite(colorIdx):
	return BillionColorSprites[colorIdx];
	
onready var spriteMaterial = $Sprite.material
export var billionSpeed: float = 3.0
export var maxBillionForce: float = 150
export var deceleration: float = 3.0
export var color = 0
export var flagDistanceThreshold: float = 100.0
# max distance between the flag and billion at any point... 
#this is a general estimate, would be better to get this through code
export var maxFlagToBillionDistance: float = 2000
export var speedCurve: Curve
var health: float = 100.0

func SetColor(colorIdx):
	color = colorIdx
	$Sprite.texture = load(GetBillionSprite(colorIdx))
	
func FindClosestFlag(posWS: Vector2):
	var closest = null
	var FlagsParent = get_node("/root/Game/Bases/Flags")
	if not FlagsParent: return null
	for child in FlagsParent.get_children():
		if closest == null or child.global_position.distance_to(posWS) < closest.global_position.distance_to(posWS):
			if child.color == self.color:
				closest = child
	return closest


func move_billion(delta):
	var closestFlag = FindClosestFlag(self.global_position)
	if closestFlag:
		var distanceToFlag: Vector2 = to_local(global_position) - to_local(closestFlag.global_position)
		var dir = -distanceToFlag.normalized()
		if distanceToFlag.length() > flagDistanceThreshold:
			self.set_linear_damp(-1)
			if self.applied_force.length() < maxBillionForce:
				self.add_central_force(dir * billionSpeed)
		else:
			self.set_linear_damp(deceleration)
			self.applied_force = Vector2.ZERO

# TODO
onready var BasesRoot = $"../../../"
# bases has children: [Flags, Base, Base2, Base3, etc]
func GetNearestEnemy():
	var nearest = null
	for child in BasesRoot.get_children():
		if "Base" in child.name and child.baseColor != color: # is a base and is not our own base
			var billionsHolder = child.get_node("Billions")
			for billion in billionsHolder.get_children():
				if nearest == null or global_position.distance_to(billion.global_position) < global_position.distance_to(nearest.global_position):
					nearest = billion
	return nearest

onready var turretLineNode = $TurretLine
func update_turret_line():	
	var local_pos = to_local(global_position)
	var to_nearest_enemy_dir = (to_local(GetNearestEnemy().global_position) - local_pos).normalized()
	var line_length = 20.0
	var to_nearest_enemy_pos = local_pos + (to_nearest_enemy_dir * line_length)
	turretLineNode.points = PoolVector2Array([local_pos, to_nearest_enemy_pos])
	
func _physics_process(delta):
	move_billion(delta)



func _process(delta):
	#update() # ensure _draw is called every frame
	update_turret_line()
	pass

func _draw():
	# draw line between billion and closest flag to visualize where they want to go
	#var closestFlag = FindClosestFlag(self.global_position)
	#if closestFlag:
		#draw_line(to_local(global_position), to_local(closestFlag.global_position), Color.red)
	

	pass

func _ready():
	health = 100.0
	

func get_billion_shader_health_value(billion_health: float):
	# as per assignment, make sure the visual health indicator doesn't go too low
	if billion_health <= 50:
		billion_health = 50
	elif billion_health <= 70:
		billion_health = 70
	elif billion_health <= 80:
		billion_health = 80
	return billion_health/100.0 # remap from [0.0, 100.0] to [0.0, 1.0]

func billion_hurt(damage: float):
	health -= damage
	spriteMaterial.set_shader_param("billionHealth", get_billion_shader_health_value(health))
	if health <= 0:
		queue_free()

func _on_Billion_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		billion_hurt(10)
	pass

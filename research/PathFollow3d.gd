extends PathFollow3D

@onready var path: Path3D = $".."

@onready var t1: PalmTree = $"../../Trees/T1"
@onready var t2: PalmTree = $"../../Trees/T2"
@onready var t3: PalmTree = $"../../Trees/T3"
@onready var t4: PalmTree = $"../../Trees/T4"
@onready var t5: PalmTree = $"../../Trees/T5"
@onready var t6: PalmTree = $"../../Trees/T6"

const MAX_HEIGHT = 100.0
const PATH_DURATION = 15.0

var markerTemplate: PackedScene = preload("res://PathMarker.tscn")	

@onready var drone: CharacterBody3D = $FollowPathDrone

func _ready() -> void:
	addPointsToPath()
	GameSingletonInstance.actualScene = self
	create_tween().tween_property(self, "progress_ratio", 1, PATH_DURATION)	
	
func _process(delta: float) -> void:
	# print(str("progress --> ", str(progress_ratio)))	
	pass

func addPointsToPath() -> void:

	"""
	path.curve.add_point(t1.global_position)
	path.curve.add_point(t2.global_position)
	path.curve.add_point(t3.global_position)
	path.curve.add_point(t4.global_position)
	path.curve.add_point(t5.global_position)
	path.curve.add_point(t6.global_position)
	"""	
	
	var bez: Bezierifier = Bezierifier.new()
	bez.addPoint(randomizeHeight(t1))
	bez.addPoint(randomizeHeight(t2))
	bez.addPoint(randomizeHeight(t3))
	bez.addPoint(randomizeHeight(t4))
	bez.addPoint(randomizeHeight(t5))
	bez.addPoint(randomizeHeight(t6))
	var baked = bez.bakePoints()
	print(str("points baked --> ", str(baked.size())))
	for p in baked:
		markPoint(p)
		path.curve.add_point(p)
		
func randomizeHeight(p: PalmTree) -> Vector3:
	var diffY = randf_range(0.0, MAX_HEIGHT)
	var result = Vector3(p.global_position.x,p.global_position.y+diffY,p.global_position.z)
	print(result)
	return result

func markPoint(p: Vector3) -> void:
	var marker = markerTemplate.instantiate()
	marker.global_position = p
	get_tree().current_scene.add_child.call_deferred(marker)

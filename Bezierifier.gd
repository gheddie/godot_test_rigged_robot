class_name Bezierifier
extends Object

var points: Dictionary[int, Vector3] = {}
var actualPointIndex: int = 0

var bakeInterval: float

const OFFSET_STEP = 1.0
const DEFAULT_BAKE_INTERVAL = 100.0

func _init() -> void:
	bakeInterval = DEFAULT_BAKE_INTERVAL
	
func addPoint(point: Vector3) -> void:
	points[actualPointIndex] = point
	actualPointIndex += 1

func bakePoints() -> Array[Vector3]:
	var result: Array[Vector3] = []
	var curve: Curve3D = Curve3D.new()
	curve.bake_interval = bakeInterval
	for pointIdx in points:
		curve.add_point(points[pointIdx])	
	print(str("get_baked_length --> "), str(curve.get_baked_length()))
	var min: float = 0.0	
	var max: float = curve.get_baked_length()
	var offset: float = min
	while offset <= max:
		result.append(curve.sample_baked(offset, true))
		offset += OFFSET_STEP
	return result

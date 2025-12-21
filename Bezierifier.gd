class_name Bezierifier
extends Object

var points: Dictionary[int, Vector3] = {}
var actualPointIndex: int = 0

var bakeInterval: float

const OFFSET_STEP = 1.0

func _init(aBakeInterval: float) -> void:
	bakeInterval = aBakeInterval

func addPoint(point: Vector3) -> void:
	points[actualPointIndex] = point
	actualPointIndex += 1

func bakePoints():
	var result = []
	var curve: Curve3D = Curve3D.new()
	curve.bake_interval = bakeInterval
	for pointIdx in points:
		curve.add_point(points[pointIdx])	
	print(str("get_baked_length --> "), str(curve.get_baked_length()))
	var min: float = 0.0	
	var max: float = curve.get_baked_length()
	var offset: float = min
	while offset <= max:
		# markIt(curve.sample_baked(offset, true), offset)
		result.append(curve.sample_baked(offset, true))
		offset += OFFSET_STEP
	return result

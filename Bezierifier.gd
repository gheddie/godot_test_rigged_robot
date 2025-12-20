class_name Bezierifier
extends Object

var points: Dictionary[int, Vector3] = {}

func addPoint(point: Vector3) -> void:
	pass

func bakePoints(offsetStep: int):
	var result = []
	var curve: Curve3D = Curve3D.new()
	curve.bake_interval = 1000000.0
	for key in points:
		curve.add_point(points[key])	
	# print(str("get_baked_length --> "), str(curve.get_baked_length()))
	var min: float = 0.0	
	var max: float = curve.get_baked_length()
	var offset: float = min
	while offset <= max:
		result.append(curve.sample_baked(offset, true))
		offset += offsetStep
	return result

extends Node3D

@onready var m0: MeshInstance3D = $CubicBezierTest/Point0
@onready var m1: MeshInstance3D = $CubicBezierTest/Point1
@onready var m2: MeshInstance3D = $CubicBezierTest/Point2
@onready var m3: MeshInstance3D = $CubicBezierTest/Point3
@onready var m4: MeshInstance3D = $CubicBezierTest/Point4
@onready var m5: MeshInstance3D = $CubicBezierTest/Point5
@onready var m6: MeshInstance3D = $CubicBezierTest/Point6
@onready var m7: MeshInstance3D = $CubicBezierTest/Point7

var markerTemplate: PackedScene = preload("res://PathMarker.tscn")	

@onready var bezierifier: Bezierifier = Bezierifier.new()

const OFFSET_STEP = 1.0

var points = []

func _ready() -> void:
	
	points.append(m0.global_position)
	bezierifier.addPoint(m0.global_position)
	
	points.append(m1.global_position)
	bezierifier.addPoint(m0.global_position)
	
	points.append(m2.global_position)
	bezierifier.addPoint(m0.global_position)
	
	points.append(m3.global_position)
	bezierifier.addPoint(m0.global_position)
	
	points.append(m4.global_position)
	bezierifier.addPoint(m0.global_position)
	
	points.append(m5.global_position)
	bezierifier.addPoint(m0.global_position)
	
	points.append(m6.global_position)
	bezierifier.addPoint(m0.global_position)
	
	points.append(m7.global_position)
	bezierifier.addPoint(m0.global_position)
	
	var resultPoints = bezierifier.bakePoints(1.0)
	"""
	for n in resultPoints:
		markIt(n, 0.0)
		"""
	
	testSampleBaked()

func testSampleBaked() -> void:
	var curve: Curve3D = Curve3D.new()
	curve.bake_interval = 1000000.0
	for point in points:
		curve.add_point(point)	
	print(str("get_baked_length --> "), str(curve.get_baked_length()))
	var min: float = 0.0	
	var max: float = curve.get_baked_length()
	var offset: float = min
	while offset <= max:
		markIt(curve.sample_baked(offset, true), offset)
		offset += OFFSET_STEP
		
func markIt(point: Vector3, offset: float) -> void:
	print(str("marking --> ", str(point), " at offset ", str(offset)))
	var marker = markerTemplate.instantiate()
	marker.global_position = point
	add_child(marker)

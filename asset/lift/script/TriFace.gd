class_name TriFace
extends Object

var point1: Vector3
var point2: Vector3
var point3: Vector3

func _init(_point1:Vector3,_point2:Vector3,_point3:Vector3) -> void:
	point1 = _point1
	point2 = _point2
	point3 = _point3

func calculateCenter() -> Vector3:
	var sumX = point1.x+point2.x+point3.x
	var sumY = point1.y+point2.y+point3.y
	var sumZ = point1.z+point2.z+point3.z
	return Vector3(sumX/3,sumY/3,sumZ/3)

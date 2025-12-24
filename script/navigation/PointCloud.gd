class_name PointCloud
extends Node

const DEFAULT = "default"

var holder: Node3D
var prefix: String

var points: Dictionary[int, Vector3] = {}
var pointCount: int

func _init(aHolder: Node3D, aPrefix: String) -> void:
	holder = aHolder
	prefix = aPrefix
	collectPoints()

func collectPoints() -> void:
	for element in holder.get_children(true):		
		if element is Node3D:
			if element.name.contains(prefix):
				var order: int = extractOrder(element.name)
				print(str(element.name), " --> " , str(order))
				points.set(order, element.global_position)
	print(str("extracted (", str(points.size()), ") points for prefix -->", prefix))
	pointCount = points.size()

func extractOrder(elementName: String) -> int:
	var tmp: String = elementName.replace(prefix, "")
	return int(tmp)

func getPointsOrdered():
	var result = []
	for pKey in points:
		result.append(points[pKey])
	return result

func randomizePoints():
	
	var result = []
	var count = randi_range(pointCount/3, pointCount)
	
	var tmpPoints: Dictionary[int, Vector3] = {}		
	for n in range(0, count):
		var randIndex = randi_range(1, pointCount)
		tmpPoints.set(randIndex, points[randIndex])
		pass
	for pKey in tmpPoints:
		result.append(tmpPoints[pKey])
	return result

func getRandomPoint() -> Vector3:
	var keys = points.keys()
	var randomKey = keys[randi_range(0,keys.size()-1)]
	return points[randomKey]

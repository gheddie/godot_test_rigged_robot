class_name NavigationSequence
extends Node3D

const APPROACH_TRESHOLD = 1.0

var node: Node3D
var prefix: String
var points: Dictionary[int, Vector3] = {}
var nextPointToApproach: int = 1
var bezierifier: Bezierifier
var bezierPoints = []
var renderContext: Node3D

var markerTemplate: PackedScene = preload("res://PathMarker.tscn")	

func _init(aNode: Node3D, aPrefix: String, bezierPath: bool, aRenderContext:Node3D) -> void:
	node = aNode
	prefix = aPrefix
	bezierifier = Bezierifier.new(100.0)
	renderContext = aRenderContext
	extractPoints()
	if bezierPath:
		bezierPoints = bezierifier.bakePoints()
		convertPointsToBezier()
		
func convertPointsToBezier() -> void:
	points.clear()
	var order: int = 0
	for bezierPoint in bezierPoints:
		points.set(order, bezierPoint)
		markInRenderContext(bezierPoint)
		order += 1
		
func markInRenderContext(point: Vector3) -> void:
	var marker = markerTemplate.instantiate()
	marker.global_position = point
	renderContext.add_child(marker)
	
func extractPoints() -> void:
	for element in node.get_children(true):		
		if element is Node3D:
			if element.name.contains(prefix):
				var order: int = extractOrder(element.name)
				print(str(element.name), " --> " , str(order))
				points.set(order, element.global_position)
				bezierifier.addPoint(element.global_position)
	print(str("extracted (", str(points.size()), ") points for prefix -->", prefix))

func extractOrder(elementName: String) -> int:
	var tmp: String = elementName.replace(prefix, "")
	return int(tmp)

func getPosition(index: int) -> Vector3:
	return points.get(index)
	
func getActualPoint() -> Vector3:
	if nextPointToApproach >= points.size():
		# reset to beginning
		nextPointToApproach = 0
	return points[nextPointToApproach]
			
func evaluateTargetDistance(follower: Node3D) -> float:
	var evaluatedTargetDistance = follower.global_position.distance_to(getActualPoint())
	if evaluatedTargetDistance <= APPROACH_TRESHOLD:
		if nextPointToApproach < points.size():
			nextPointToApproach += 1
		else:
			nextPointToApproach = 1
	return evaluatedTargetDistance
	
func evaluateTargetAngle(follower: Node3D) -> float:
	# var followerRotation = rad_to_deg(follower.global_rotation.y)
	# print(str("follower rotation --> ", str(follower.global_rotation)))
	# return rad_to_deg(follower.get_global_transform().basis.z.angle_to(getActualPoint()))
	# return rad_to_deg(follower.get_global_transform().basis.x.angle_to(getActualPoint()))
	return rad_to_deg(follower.global_rotation.angle_to(getActualPoint()))
	# return follower.rotation.angle_to(getActualPoint())
	
func bezier(startPoint: int):
	
	var result = []
	
	var p0 = points[startPoint]
	var p1 = points[startPoint+1]
	var p2 = points[startPoint+2]
	var p3 = points[startPoint+3]
	var p4 = points[startPoint+4]
	var p5 = points[startPoint+5]
	
	var t = 0.0
	while t < 1.0:
		t += 0.01
		var q0 = p0.lerp(p1, t)
		var q1 = p1.lerp(p2, t)
		var q3 = p2.lerp(p3, t)
		var q4 = p3.lerp(p4, t)
		var q5 = p4.lerp(p5, t)
		var r = q0.lerp(q5, t)
		result.append(r)	
	return result

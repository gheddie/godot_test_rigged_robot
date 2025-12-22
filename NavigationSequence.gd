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
var pointCloudIdentifier: String
var pointCloud: PointCloud

var markerTemplate: PackedScene = preload("res://PathMarker.tscn")	

func _init(aNode: Node3D, aPrefix: String, bezierPath: bool, aRenderContext:Node3D, aPointCloudIdentifier: String) -> void:
	node = aNode
	prefix = aPrefix
	bezierifier = Bezierifier.new(100.0)
	renderContext = aRenderContext
	pointCloudIdentifier = aPointCloudIdentifier
	pointCloud = PlayerAccessInstance.getPointCloud(pointCloudIdentifier)
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
	var pointOrder: int = 0
	# var pointsFromCloud = pointCloud.getPointsOrdered()
	var pointsFromCloud = pointCloud.randomizePoints()
	for point in pointsFromCloud:
		points.set(pointOrder, point)
		bezierifier.addPoint(point)
		pointOrder += 1

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

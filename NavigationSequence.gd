class_name NavigationSequence
extends Node3D

const APPROACH_TRESHOLD = 1.0

var node: Node3D
var points: Dictionary[int, Vector3] = {}
var nextPointToApproach: int = 1
var bezierifier: Bezierifier
var bezierPoints = []
var renderContext: Node3D
var pointCloudIdentifier: String
var pointCloud: PointCloud
var drone: Drone

var markerTemplate: PackedScene = preload("res://PathMarker.tscn")	

func _init(bezierPath: bool, aRenderContext:Node3D, aPointCloudIdentifier: String) -> void:
	bezierifier = Bezierifier.new()
	renderContext = aRenderContext
	pointCloudIdentifier = aPointCloudIdentifier
	pointCloud = GameSingletonInstance.getPointCloud(pointCloudIdentifier)
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
	# var marker = markerTemplate.instantiate()
	# marker.global_position = point
	# renderContext.add_child(marker)
	pass
	
func extractPoints() -> void:
	var pointOrder: int = 0
	# var pointsFromCloud = pointCloud.getPointsOrdered()
	var pointsFromCloud = pointCloud.randomizePoints()
	for point in pointsFromCloud:
		points.set(pointOrder, point)
		bezierifier.addPoint(point)
		pointOrder += 1

func getPosition(index: int) -> Vector3:
	return points.get(index)
	
func getActualPoint() -> Vector3:
	if nextPointToApproach >= points.size():
		# reset to beginning
		drone.onNavigationFinished()
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

func getStartPoint() -> Vector3:
	return points[0]

class_name NavigationPath
extends Object

var pointsArray: Array[Vector3]
var bakedPoints: Array[Vector3]

var actualBezierPoint: int = 0
var actualPoint: int = 0
var renderContext: Node3D
var follower: Drone

const TRIGGER_DISTANCE_BEZIER = 0.5
const TRIGGER_DISTANCE = 10.0

const PROVOKE_DIST = 200.0

func _init(aFollower: Node3D) -> void:
	follower = aFollower
	pointsArray.append(GameSingletonInstance.getPointCloud(PointCloud.DEFAULT).getRandomPoint())
	# add 2 more points
	extendPoints()
	extendPoints()
	bakedPoints = calculateBezierPoints()
	renderPoints(bakedPoints)
	
func renderPoints(points: Array[Vector3]) -> void:
	for point in points:
		GameSingletonInstance.drawMarkerInActualScene(point, false)
	
func calculateBezierPoints() -> Array[Vector3]:
	var bezierifier: Bezierifier = Bezierifier.new()
	for point in pointsArray:
		bezierifier.addPoint(point)
	var baked = bezierifier.bakePoints()
	print(str("calculated ", str(baked.size(), " bezier points.")))
	return baked
	
func extendPoints() -> void:
	var opponentInRange = checkForOpponentInRange()
	if opponentInRange != null:
		print("ATTACK!!!")
		follower.provoked = true
		pointsArray.append(opponentInRange.global_position)
	else:
		pointsArray.append(GameSingletonInstance.getPointCloud(PointCloud.DEFAULT).getRandomPoint())
		
func checkForOpponentInRange():	
	if follower.global_position.distance_to(GameSingletonInstance.player.global_position) <= PROVOKE_DIST:
		return GameSingletonInstance.player
	else:
		return null

func debug() -> void:
	print("------------------------------------")
	var index: int = 0
	for point in pointsArray:
		print(str(index), " --> ", str(point))
		index+=1

func getInitialPoint():
	return pointsArray[0]

func getFollowingBezierPoint() -> Vector3:
	return bakedPoints[actualBezierPoint+1]
	
func getActualPoint() -> Vector3:
	return pointsArray[actualPoint]
	
func getActualBezierPoint() -> Vector3:
	return bakedPoints[actualBezierPoint]
	
func getFollowingPoint() -> Vector3:
	return pointsArray[actualPoint+1]

func onPositionChanged(followerPosition: Vector3) -> void:	
	var distanceToFollower = followerPosition.distance_to(getFollowingPoint())
	var distanceToBezierFollower = followerPosition.distance_to(getFollowingBezierPoint())
	if (distanceToFollower <= TRIGGER_DISTANCE):
		extendBezier()
		actualPoint += 1		
	if (distanceToBezierFollower <= TRIGGER_DISTANCE_BEZIER):
		actualBezierPoint += 1		

func extendBezier() -> void:
	extendPoints()
	var calculated = calculateBezierPoints()	
	var additionalCount = calculated.size() - bakedPoints.size()
	var additionalPoints = calculated.slice(bakedPoints.size(), calculated.size())
	bakedPoints.append_array(additionalPoints)	
	renderPoints(additionalPoints)

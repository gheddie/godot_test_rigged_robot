class_name NavigationProvider
extends Node

var navigationContext: Node3D
var navigationAreaPrefix: String

const RAND_DIFF = 5000.0

func _init(aNavigationContext:Node3D, aNavigationAreaPrefix:String) -> void:
	navigationContext = aNavigationContext
	navigationAreaPrefix = aNavigationAreaPrefix
	extractNavigationAreas()
	
func extractNavigationAreas() -> void:
	for element in navigationContext.get_children(true):		
		if element is Node3D:
			if element.name.contains(navigationAreaPrefix):
				var order: int = extractOrder(element.name)
				print(str(element.name), " --> " , str(order))
				var area = Area3D.new()
				print(element.global_position.x)
				print(element.global_position.y)
				print(element.global_position.z)
				print(element.scale.x)
				print(element.scale.y)
				print(element.scale.z)
				
				# points.set(order, element.global_position)
				# bezierifier.addPoint(element.global_position)
	# print(str("extracted (", str(points.size()), ") points for prefix -->", prefix))
	
func extractOrder(elementName: String) -> int:
	var tmp: String = elementName.replace(navigationAreaPrefix, "")
	return int(tmp)

func createNavigationSequence(navigationOwner: Node3D) -> NavigationSequence:
	
	print(str("creating navigation sequence for owner --> ", str(navigationOwner)))
	print(str("creating navigation sequence in context --> ", str(navigationContext)))
	
	var sequence: NavigationSequence = NavigationSequence.new(navigationContext)
	
	# add points	
	var pointIndex: int = 0
	for randomizedPoint in randomizePointsFromRenderContext(navigationContext):
		sequence.addPoint(randomizedPoint, pointIndex);	
		pointIndex += 1	
	
	sequence.bake()
	return sequence

func randomizePointsFromRenderContext(navigationContext: Node3D):
	
	var count: int = randi_range(0,100)
	
	print(str("randomizing points from render context --> ", str(navigationContext)), " ---> ", str(count))
	print(str("render context size --> ", str(navigationContext.scale)))
	
	var result = []
	
	for n in range(0,count,1):
		result.append(randomizePoint(navigationContext))
	
	"""
	result.append(
		Vector3(
			navigationContext.global_position.x+10,navigationContext.global_position.y,navigationContext.global_position.z))	
	result.append(
		Vector3(
			navigationContext.global_position.x+100,navigationContext.global_position.y,navigationContext.global_position.z+3.0))
	result.append(
		Vector3(
			navigationContext.global_position.x+128,navigationContext.global_position.y-17.0,navigationContext.global_position.z))	
			"""
	
	return []

func randomizePoint(navigationContext: Node3D) -> Vector3:
	
	var diffX = randf_range(-RAND_DIFF, RAND_DIFF)
	var diffY = randf_range(-RAND_DIFF, RAND_DIFF)
	var diffZ = randf_range(-RAND_DIFF, RAND_DIFF)
	
	var result: Vector3 = Vector3(
		navigationContext.global_position.x + diffX,
		navigationContext.global_position.y + diffY,
		navigationContext.global_position.z + diffZ
		)
		
	print(str("randomized point --> ", str(result)))

	return result

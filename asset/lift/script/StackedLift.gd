class_name StackedLift
extends Node3D

var basePosition: Vector3
var height: float
var startTop: bool
var scaleFactor: float
var verticalSpeed: float

var bottom: LiftFrame
var top: LiftFrame

var targetFrame: LiftFrame

var platform: LiftPlatform

var liftFrameTemplate: PackedScene = preload("res://asset/lift/scene/LiftFrame.tscn")	
var liftPlatformTemplate: PackedScene = preload("res://asset/lift/scene/LiftPlatform.tscn")	

enum StackedLiftAction {IDLE_BOTTOM, IDLE_TOP, ASCENDING, DESCENDING}

var actualLiftAction: StackedLiftAction

func _init(aBasePosition: Vector3, aHeight: float, aStartTop: bool, aScaleFactor: float, aVerticalSpeed: float) -> void:
	basePosition = aBasePosition
	height = aHeight
	startTop = aStartTop
	scaleFactor = aScaleFactor
	verticalSpeed = aVerticalSpeed
	actualLiftAction = StackedLiftAction.IDLE_BOTTOM

func renderInScene(parent: Node3D) -> void:
	# bottom
	bottom = liftFrameTemplate.instantiate()
	bottom.global_position = basePosition
	parent.add_child(scaleIt(bottom))
	# top
	top = liftFrameTemplate.instantiate()
	top.global_position = Vector3(basePosition.x, basePosition.y+height, basePosition.z)	
	parent.add_child(scaleIt(top))
	# platform
	platform = liftPlatformTemplate.instantiate()
	platform.global_position = Vector3(basePosition.x, basePosition.y, basePosition.z)	
	platform.lift = self
	parent.add_child(scaleIt(platform))

func scaleIt(elementToScale: Node3D) -> Node3D:
	elementToScale.scale = Vector3(elementToScale.scale.x*scaleFactor,elementToScale.scale.y*scaleFactor,elementToScale.scale.z*scaleFactor)
	return elementToScale

func platformInvoked() -> void:
	print("lift platform invoked...")
	if (actualLiftAction == StackedLiftAction.IDLE_BOTTOM):
		actualLiftAction = StackedLiftAction.ASCENDING
		targetFrame = top
	if (actualLiftAction == StackedLiftAction.IDLE_TOP):
		actualLiftAction = StackedLiftAction.DESCENDING
		targetFrame = bottom

func onProcess(_delta: float) -> void:
	if (actualLiftAction == StackedLiftAction.ASCENDING):
		platform.rise(_delta)
	if (actualLiftAction == StackedLiftAction.DESCENDING):
		platform.fall(_delta)

func platformMoved(newPlatformPos: Vector3) -> void:
	print(str("platform moved to --> ", str(newPlatformPos.y)))
	var distanceToTarget = abs(platform.global_position.y - targetFrame.global_position.y)
	if (distanceToTarget < 0.1):
		targetFrameReached()

func targetFrameReached() -> void:	
	if actualLiftAction == StackedLiftAction.ASCENDING:
		actualLiftAction = StackedLiftAction.IDLE_TOP
	if actualLiftAction == StackedLiftAction.DESCENDING:
		actualLiftAction = StackedLiftAction.IDLE_BOTTOM
	
func isMoving() -> bool:
	return actualLiftAction == StackedLiftAction.ASCENDING or actualLiftAction == StackedLiftAction.DESCENDING

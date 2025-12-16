class_name StackedLift
extends Node3D

var basePosition: Vector3
var height: float
var startTop: bool
var scaleFactor: float

var bottom: LiftFrame
var top: LiftFrame

var platform: LiftPlatform

var liftFrameTemplate: PackedScene = preload("res://asset/lift/scene/LiftFrame.tscn")	
var liftPlatformTemplate: PackedScene = preload("res://asset/lift/scene/LiftPlatform.tscn")	

func _init(aBasePosition: Vector3, aHeight: float, aStartTop: bool, aScaleFactor: float) -> void:
	basePosition = aBasePosition
	height = aHeight
	startTop = aStartTop
	scaleFactor = aScaleFactor

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
	parent.add_child(scaleIt(platform))

func scaleIt(elementToScale: Node3D) -> Node3D:
	elementToScale.scale = Vector3(elementToScale.scale.x*scaleFactor,elementToScale.scale.y*scaleFactor,elementToScale.scale.z*scaleFactor)
	return elementToScale

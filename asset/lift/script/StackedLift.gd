class_name StackedLift
extends Node3D

var basePosition: Vector3
var height: float
var startTop: bool

var bottom: LiftFrame
var top: LiftFrame

var platform: LiftPlatform

var liftFrameTemplate: PackedScene = preload("res://asset/lift/scene/LiftFrame.tscn")	
var liftPlatformTemplate: PackedScene = preload("res://asset/lift/scene/LiftPlatform.tscn")	

func _init(aBasePosition: Vector3, aHeight: float, aStartTop: bool) -> void:
	basePosition = aBasePosition
	height = aHeight
	startTop = aStartTop

func renderInScene(parent: Node3D) -> void:
	# bottom
	bottom = liftFrameTemplate.instantiate()
	bottom.global_position = basePosition
	parent.add_child(bottom)
	# top
	top = liftFrameTemplate.instantiate()
	top.global_position = Vector3(basePosition.x, basePosition.y+height, basePosition.z)	
	parent.add_child(top)
	# platform
	platform = liftPlatformTemplate.instantiate()
	platform.global_position = Vector3(basePosition.x, basePosition.y, basePosition.z)	
	parent.add_child(platform)

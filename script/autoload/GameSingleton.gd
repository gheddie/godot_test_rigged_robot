class_name GameSingleton
extends Node

var player: RobotNew
var actualScene: Node3D

var pointclouds: Dictionary[String, PointCloud] = {}
var droneTemplate: PackedScene = preload("res://asset/drone/Drone.tscn")	

var navigationProvider: NavigationProvider = NavigationProvider.new()

var markerTemplate: PackedScene = preload("res://PathMarker.tscn")	
var markerTemplateEnhanced: PackedScene = preload("res://PathMarkerEnhanced.tscn")	

func registerPointCloud(holder: Node3D, elementPrefix: String, identifier: String) -> void:	
	pointclouds.set(identifier, PointCloud.new(holder, elementPrefix))	
	
func getPointCloud(identifier: String) -> PointCloud:	
	return pointclouds[identifier]		

func makeDrone(aRenderContext: Node3D) -> Drone:
	var drone: Drone = droneTemplate.instantiate()
	drone.global_position = getRandomPoint()
	return drone

func getRandomPoint() -> Vector3:
	return getPointCloud(PointCloud.DEFAULT).getRandomPoint()

func getNavigationPath(follower: Node3D) -> NavigationPath:
	return navigationProvider.getNavigationPath(follower)

func drawMarkerInActualScene(position: Vector3, enhanced: bool) -> void:
	if enhanced:
		var marker = markerTemplateEnhanced.instantiate()
		marker.global_position = position
		actualScene.add_child(marker)
	else:
		var marker = markerTemplate.instantiate()
		marker.global_position = position
		actualScene.add_child(marker)

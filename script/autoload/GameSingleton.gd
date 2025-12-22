class_name GameSingleton
extends Node

var player: Node3D

var navigationProvider: NavigationProvider

var droneTemplate: PackedScene = preload("res://asset/drone/Drone.tscn")	

func registerNavigationAreas(navigationContext: Node3D, navigationAreaPrefix: String):
	navigationProvider = NavigationProvider.new(navigationContext, navigationAreaPrefix)

func makeDrone(position: Vector3) -> Drone:
	var drone: Drone = droneTemplate.instantiate()
	drone.global_position = position	
	drone.navigationSequence = navigationProvider.createNavigationSequence(drone)	
	return drone

class_name PlayerAccess
extends Node

var player: RobotNew

var pointclouds: Dictionary[String, PointCloud] = {}

func registerPointCloud(holder: Node3D, elementPrefix: String, identifier: String) -> void:	
	pointclouds.set(identifier, PointCloud.new(holder, elementPrefix))	
	
func getPointCloud(identifier: String) -> PointCloud:	
	return pointclouds[identifier]
		

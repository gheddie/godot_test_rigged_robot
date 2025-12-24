class_name NavigationProvider
extends Node

func getNavigationPath(follower: Node3D) -> NavigationPath:
	return NavigationPath.new(follower)

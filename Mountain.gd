class_name Mountain
extends StaticBody3D

var treeInstance: PackedScene = preload("res://PalmTree.tscn")	

func _ready() -> void:
	for element in get_all_children(get_tree().get_root()):		
		if element is Node3D:
			if element.name.contains("AssetMarker"):
				# print(element.name)			
				# putTree(element.global_position)
				pass
				
func putTree(pos: Vector3) -> void:
	print("putting tree...")
	var newTree: PalmTree = treeInstance.instantiate()	
	# newTree.global_position = pos
	get_tree().get_current_scene().add_child(newTree)

func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array

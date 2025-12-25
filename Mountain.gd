class_name Mountain
extends StaticBody3D

var treeInstance: PackedScene = preload("res://PalmTree.tscn")	
var markerTemplateEnhanced: PackedScene = preload("res://PathMarkerEnhanced.tscn")	

@onready var landScape: MeshInstance3D = $Landscape

func _ready() -> void:
	investigateMesh(landScape)
	for element in get_all_children(get_tree().get_root()):	
		if element is Node3D:
			if element.name.contains("AssetMarker"):
				# print(element.name)			
				# putTree(element.global_position)
				pass
				
func investigateMesh(meshInstance: MeshInstance3D) -> void:
	
	var st = SurfaceTool.new()
	var material = generateMaterial()
	var m: Mesh = meshInstance.mesh
	print(str(m.get_surface_count()), str(" surfaces..."))
	var tri: TriangleMesh = m.generate_triangle_mesh()
	var faces: PackedVector3Array = tri.get_faces()
	print(str(faces.size()), str(" tri surfaces..."))
	for n in range(0,faces.size(),3):
		markFace(TriFace.new(faces.get(n),faces.get(n+1),faces.get(n+2)), st, material, false, true)

func generateMaterial() -> StandardMaterial3D:
	var material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	return material
		
func markFace(face: TriFace, tool: SurfaceTool,
	material: StandardMaterial3D, putMarker: bool, putFace: bool) -> void:
	if putFace:
		putFace(tool, face, material)
	if putMarker:
		putMarker(face)
	
func putMarker(face: TriFace) -> void:
	var marker = markerTemplateEnhanced.instantiate()
	marker.global_position = face.calculateCenter()
	add_child(marker)
	
func putFace(tool: SurfaceTool, face: TriFace, material: StandardMaterial3D) -> void:
	tool.begin(Mesh.PRIMITIVE_LINE_STRIP)
	tool.add_vertex(face.point1)
	tool.add_vertex(face.point2)
	tool.add_vertex(face.point3)	
	tool.generate_normals(true)
	var meshInstance = MeshInstance3D.new()
	meshInstance.mesh = tool.commit()
	meshInstance.material_override = material
	add_child(meshInstance)
	
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

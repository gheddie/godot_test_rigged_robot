extends Node3D

var robotInstance: PackedScene = preload("res://RobotNew.tscn")	

@onready var surfaceTool: SurfaceTool = SurfaceTool.new()

@onready var sp1: MeshInstance3D = $Spheres/Sphere1
@onready var sp2: MeshInstance3D = $Spheres/Sphere2
@onready var sp3: MeshInstance3D = $Spheres/Sphere3

func _ready() -> void:
	
	# add_child(robotInstance.instantiate())
	
	print(sp1.global_position)
	print(sp2.global_position)
	print(sp3.global_position)

	createMesh()
	
func createMesh() -> void:
	
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	"""
	surfaceTool.set_normal(Vector3(0, 0, 1))
	surfaceTool.set_uv(Vector2(0, 0))
	surfaceTool.add_vertex(Vector3(-1, -1, 0))

	surfaceTool.set_normal(Vector3(0, 0, 1))
	surfaceTool.set_uv(Vector2(0, 1))
	surfaceTool.add_vertex(Vector3(-1, 1, 0))

	surfaceTool.set_normal(Vector3(0, 0, 1))
	surfaceTool.set_uv(Vector2(1, 1))
	surfaceTool.add_vertex(Vector3(1, 1, 0))
	"""
	
	surfaceTool.add_vertex(Vector3(-1.0, 0.0, -1.0))
	surfaceTool.add_vertex(Vector3(1.0, 0.0, -1.0))
	surfaceTool.add_vertex(Vector3(1.0, 0.0, 1.0))
	
	"""
	surfaceTool.add_vertex(Vector3(-1,0,-1))
	surfaceTool.add_vertex(Vector3(-1,0,1))
	surfaceTool.add_vertex(Vector3(1,0,0-1))
	surfaceTool.add_vertex(Vector3(1,0,1))
	"""
	
	"""
	surfaceTool.add_vertex(Vector3(-1.0, 0.0, -1.0))
	surfaceTool.add_vertex(Vector3(1.0, 0.0, -1.0))
	surfaceTool.add_vertex(Vector3(1.0, 0.0, 1.0))
	surfaceTool.add_vertex(Vector3(-1.0, 0.0, 1.0))
	"""
	
	var createdMesh: ArrayMesh = surfaceTool.commit()
	var meshInstance = MeshInstance3D.new()
	meshInstance.mesh = createdMesh
	add_child(meshInstance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

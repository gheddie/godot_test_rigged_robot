extends PathFollow3D

func _ready() -> void:
	create_tween().tween_property(self, "progress_ratio", 1, 5.0)
	pass

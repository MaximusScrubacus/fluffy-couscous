extends MeshInstance3D

@export var damage := 25
signal body_part_hit(dam)

func hit():
	emit_signal("body_part_hit",damage)

extends Area3D

@export var damage = 25

signal  body_part_hit(damage)

func hit():
	emit_signal("body_part_hit", damage)

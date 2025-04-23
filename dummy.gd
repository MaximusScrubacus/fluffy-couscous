extends CharacterBody3D

@export var player_path : NodePath
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var animation_player: AnimationPlayer = $CollisionShape3D/DummyAnims/AnimationPlayer
@onready var animation_tree: AnimationTree = $CollisionShape3D/DummyAnims/AnimationPlayer/AnimationTree
@onready var area_3d: Area3D = $CollisionShape3D/Area3D
@onready var hit_timer: Timer = $HitTimer
@onready var ragdoll: PhysicalBoneSimulator3D = $CollisionShape3D/DummyAnims/Armature/Skeleton3D/PhysicalBoneSimulator3D


var player = null
var health = 100
#var healthBar = health
const  SPEED = 3.0 
const ATTACK_RANGE = 2.5

func take_damage(amount : int ) -> void:
	health -= amount
	$HitTimer.start()
	animation_tree["parameters/conditions/hit"] = true
	if health == 0.0:
		$CollisionShape3D/DummyAnims/Armature/Skeleton3D/PhysicalBoneSimulator3D.physical_bones_start_simulation()

func health_update():
	%ProgressBar.value = health

#Navigation Code
#region New Code Region
func _ready() -> void:
	player = get_node(player_path)

func _process(_delta: float) -> void:
	navigation_agent_3d.set_target_position(player.global_transform.origin)
	var next_nav_point = navigation_agent_3d.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	move_and_slide()
	health_update()
#endregion


func _on_hit_timer_timeout() -> void:
		animation_tree["parameters/conditions/hit"] = false

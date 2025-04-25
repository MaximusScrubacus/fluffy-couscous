extends CharacterBody3D

@export var player_path : NodePath
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var hit_timer: Timer = $HitTimer
@onready var health_bar: Node3D = $"Health Bar"
@onready var blood_splat: Node3D = $bloodSplat
@onready var animation_tree: AnimationTree = $EnemyDummy/AnimationPlayer/AnimationTree
@onready var animation_player: AnimationPlayer = $EnemyDummy/AnimationPlayer
@onready var ragdoll: PhysicalBoneSimulator3D = $EnemyDummy/Armature_001/GeneralSkeleton/Ragdoll
@onready var world_collider: CollisionShape3D = $WorldCollider
@onready var hurtbox_collider: CollisionShape3D = $Hurtbox/CollisionShape3D
@onready var audio_stream_player: AudioStreamPlayer = $Node/AudioStreamPlayer




var dummy_is_dead = false
var player = null
var health = 100
#var healthBar = health
const  SPEED = 3.0 
const ATTACK_RANGE = 2.5

func take_damage(amount : int ) -> void:
	health -= amount
	$HitTimer.start()
	audio_stream_player.play()
	$bloodSplat/bloodParticle.emitting = true	
	animation_tree["parameters/conditions/hit"] = true
	if health == 0.0:
		dummy_is_dead = true
		health_bar.hide()
		world_collider.disabled = true
		hurtbox_collider.disabled = true
		ragdoll.physical_bones_start_simulation()
		

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
	if dummy_is_dead != true :
		move_and_slide()
	health_update()
#endregion


func _on_hit_timer_timeout() -> void:
		animation_tree["parameters/conditions/hit"] = false

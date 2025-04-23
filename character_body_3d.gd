extends CharacterBody3D
#body.health -= melee_damage
#Movement Variables
var speed 
const WALK_SPEED = 5.0
const  SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = .01
var attack_enabled = true
#Head Bob Variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

@onready var head: Node3D = $Head
@onready var camera_3d: Camera3D = $Head/Camera3D
@onready var hitbox: Area3D = $Head/Camera3D/KnightSkin/LowPolyKnightArm/metarig/Skeleton3D/Cube/Hitbox
@onready var animation_player: AnimationPlayer = $Head/Camera3D/KnightSkin/LowPolyKnightArm/AnimationPlayer
@onready var sword_cam: Camera3D = $"Head/Camera3D/SubViewportContainer/SubViewport/Sword Cam"
@onready var Lantern: OmniLight3D = $Head/Camera3D/OmniLight3D
@onready var sword_swing: AudioStreamPlayer = $swordSwing






#code for sword_cam viewport to match main viewport
func _process(delta: float) -> void:
	sword_cam.global_transform = camera_3d.global_transform

#Hitbox/anim for melee swing
func melee():
	if Input.is_action_just_pressed("fire") && attack_enabled:
		if	animation_player.is_playing():
			animation_player.play_backwards("Sword_Attack")
			animation_player.queue("Sword_Idle")
		if animation_player.current_animation == "Sword_Attack":
			%Timer.start()
			attack_enabled = false
			sword_swing.play()
#			Testing HIT/HURTBOXES Commented OUT
			#for body in hitbox.get_overlapping_bodies():
				#if body.is_in_group("Enemy"):
					#print("test")

# player torch on/off switch
#region New Code Region
func torchSwitch ():
		if Input.is_action_pressed("Torch") && Lantern.visible == false:
			Lantern.show()
			
		elif Input.is_action_just_pressed("Torch") && Lantern.visible == true :
			Lantern.hide()
#endregion



#Mouse Modes
#region New Code Region
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left-click"): 
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	torchSwitch()
#endregion


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera_3d.rotate_x(-event.relative.y * SENSITIVITY)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-40), deg_to_rad(40))
		
func _physics_process(delta: float) -> void:
#Raycast hand for object interaction
	%interactText.hide()
	if %handOfGod.is_colliding():
		var target = %handOfGod.get_collider()
		if target != null and target.is_in_group("Interactable") :
			%interactText.show()
		if Input.is_action_just_pressed("Interact"):
			target.interact()
		
	melee()
	
	#Sprint
#region New Code Region
	if Input.is_action_pressed("Sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
#endregion

	# Add the gravity.
#region New Code Region
	if not is_on_floor():
		velocity += get_gravity() * delta
#endregion

	# Handle jump.
#region New Code Region
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
#endregion

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z= lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z= lerp(velocity.z, direction.z * speed, delta * 2.0)
			
	#Head Bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera_3d.transform.origin = _headbob(t_bob)

	move_and_slide()
	
	
func _headbob(time):
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/2) * BOB_AMP
	return pos


func _on_timer_timeout() -> void:
	attack_enabled = true	

extends CharacterBody3D


@export var speed = 14
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 16		#continue jump height

var target_velocity = Vector3.ZERO

signal hit

func _physics_process(delta):
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y = jump_impulse
	#create local var store input direction
	var direction = Vector3.ZERO
	
	#ở môi trường 3d, XZ là mặt ngang (ground)
	if Input.is_action_pressed("move_right"):
		direction.x +=1
	if Input.is_action_pressed("move_left"):
		direction.x -=1
	if Input.is_action_pressed("move_forward"):
		direction.z -=1
	if Input.is_action_pressed("move_back"):
		direction.z +=1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
	
	#Ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	#Lặp lại tất cả các va chạm xảy ra ở khung này
	for index in range (get_slide_collision_count()):
		#Kiểm tra từng collision đang va chạm với player
		var collision = get_slide_collision(index)
		#Nếu collision is with ground
		if(collision.get_collider()==null):
			continue
		#Neu collider la mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			#Kiem tra co phai hit tu phia tren hay khong
			if Vector3.UP.dot(collision.get_normal())>0.1:
				mob.squash()
				target_velocity.y = bounce_impulse
	velocity = target_velocity
	move_and_slide()
	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
		

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(body):
	die()

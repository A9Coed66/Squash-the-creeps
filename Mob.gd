extends CharacterBody3D

@export var min_speed = 10
@export var max_speed = 18
# Emitted when the player jumped on the mob.
signal squashed
func _physics_process(delta):
	
	move_and_slide()

#Đây là hàm quản lí việc khởi tạo Mob, viết tại Mob, gọi ở main
func initialize(start_position, player_position):
	#Vị trí mob spawn là start_position
	#rotate hướng tới player
	look_at_from_position(start_position, player_position, Vector3.UP)
	#Thay đổi góc y của Mob một góc ngẫu nhiên
	rotate_y(randf_range(-PI/4, PI/4))
	
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	
	#chưa hiểu lắm: điều gì sẽ xảy ra khi loại bỏ hàm này
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	$AnimationPlayer.speed_scale = random_speed * 2 / min_speed

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
	
func squash():
	squashed.emit()
	queue_free()

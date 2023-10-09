extends CharacterBody2D

# export variabel agar visible pada inspector
@export var speed = 100
@export var gravity = 200
@export var jump_height = -100

# variabel movement state
var is_attacking = false
var is_climbing = false

# fungsi untuk memproses input physics secara iterasi
func _physics_process(delta):
	# meng-apply efek graviti == delta
	velocity.y += gravity * delta
	
	# meng-apply gerakan horizontal (kanan kiri)
	horizontal_movement()
	
	# meng-apply animasi
	if !is_attacking:
		player_animations()
	
	# meng-apply semua physic proses yang sudah dibuat sebelumnya
	move_and_slide()

# fungsi input digunakan sesuai peristiwa yang muncul
func _input(event):
	# ketika menyerang menekan shift, play animasi
	if event.is_action_pressed("ui_attack"):
		is_attacking = true
		$AnimatedSprite2D.play("attack")
		
	# ketika menekan space maka akan melompat 
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		$AnimatedSprite2D.play("jump")
	
	# ketika berinteraksi dengan tangga maka climbing == true
	if is_climbing == true:
		if event.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play("climb")
			gravity = 100
			velocity.y = -200
	
	# reset gravity setelah selesai climb
	else :
		gravity = 200
		is_climbing = false

func horizontal_movement():
	# return 1 dan -1 saat menekan input map 
	var horizontal_input = Input.get_axis("ui_left", "ui_right")
	
	# velocity untuk menggerakkan player sesuai dengan speed * horizontal_input
	velocity.x = horizontal_input * speed
	

# fungsi untuk menjalankan animasi (kebanyakan loop)
func player_animations():
	# ke kiri dan menggunakan is_action_just_released untuk berlari setelah melompat
	if Input.is_action_pressed("ui_left") || Input.is_action_just_released("ui_jump"):
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = 1.5
	
	# ke kanan dan menggunakan is_action_just_released untuk berlari setelah melompat
	if Input.is_action_pressed("ui_right") || Input.is_action_just_released("ui_jump"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = -1.5
	
	# idle karena tidak menekan apa-apa (not input anything)
	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle")

# signal untuk animasi selesai dari AnimatedSprite2D
func _on_animated_sprite_2d_animation_finished():
	is_attacking = false

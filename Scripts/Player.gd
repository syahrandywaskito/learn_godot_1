extends CharacterBody2D

# visible in inspector editor
@export var speed : float = 300.0

# get node on tree and make it onready
@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine

# Normal variable
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO

func _ready():
	animation_tree.active = true

func _process(_delta):
	update_animation()
	update_facing_direction()

func _physics_process(delta):
	gravity_handler(delta)
	move_direction_handler()
	move_and_slide()
	
func move_direction_handler():
	direction = Input.get_vector("left", "right", "up", "down")
	
	if direction.x != 0 and state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func gravity_handler(delta : float):
	if not is_on_floor():
		velocity.y += gravity * delta

func update_animation():
	animation_tree.set("parameters/Move/blend_position", direction.x)
	
func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true

extends Node

class_name State

# Editor visible State Class Property
@export var can_move : bool = true

# State Class Property
var character : CharacterBody2D
var next_state : State

# State Class Method can extend to child
func state_input(_event : InputEvent):
	pass

func on_enter():
	pass
	
func on_exit():
	pass

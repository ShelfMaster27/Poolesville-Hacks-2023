extends KinematicBody2D

var velocity = Vector2.ZERO
onready var _animated_sprite = $AnimatedSprite

var animation: int = PlayerAnim.RIGHT_IDLE
var _move_x = MoveX.IDLE
var _move_y = MoveY.IDLE

enum MoveX { IDLE, RIGHT, LEFT = -1 }

enum MoveY { IDLE, DOWN, UP = -1 }

enum PlayerAnim {
	LEFT, LEFT_IDLE, RIGHT, RIGHT_IDLE, UP, UP_IDLE,
}

# tremble and weep - nangs
func process_input():
	_move_x = MoveX.IDLE
	_move_y = MoveY.IDLE

	if Input.is_action_pressed("ui_right"):
		_move_x += MoveX.RIGHT
	if Input.is_action_pressed("ui_left"):
		_move_x += MoveX.LEFT

	if Input.is_action_pressed("ui_up"):
		_move_y += MoveY.UP

	if _move_x != MoveX.IDLE:
		animation = _move_x + 1
	elif _move_y != MoveY.IDLE:
		animation = _move_y + 5
	else:
		animation += 1 - (animation % 2)

func _process(_delta):
	process_input()
	
	_animated_sprite.flip_h = animation < PlayerAnim.RIGHT
	match animation:
		PlayerAnim.RIGHT, PlayerAnim.LEFT:
			_animated_sprite.play("right")
		
		PlayerAnim.UP:
			_animated_sprite.play("backward")
		PlayerAnim.RIGHT_IDLE, PlayerAnim.LEFT_IDLE:
			_animated_sprite.play("idle right")
		
		PlayerAnim.UP_IDLE:
			_animated_sprite.play("idle backward")

func _physics_process(delta):
	velocity = Vector2(_move_x, _move_y).normalized() * 150
	move_and_collide(velocity * delta)

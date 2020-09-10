extends Area2D

signal hit
export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func move(velocity):
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	elif Input.is_action_pressed("ui_down"):
		velocity.y += 1
	return velocity

func animate_move_sprite(velocity):
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
		
func animate_sprite(velocity):
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
		animate_move_sprite(velocity)
	else:
		$AnimatedSprite.stop()
	return velocity

func update_position(delta, velocity):
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _process(delta):
	var velocity = Vector2()
	velocity = move(velocity)
	velocity = animate_sprite(velocity)
	update_position(delta, velocity)

func _on_Player_body_entered(_body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(position):
	self.position = position
	show()
	$CollisionShape2D.disabled = false

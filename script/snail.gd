extends Area2D
@onready var animated_sprite_2d = $AnimatedSprite2D

signal player_died
const SPEED = 40.0
var direction = -1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += direction * SPEED * delta


func _on_timer_timeout():
	direction *= -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h


func _on_body_entered(body):
	if body.name == "Player" and body.alive:
		emit_signal("player_died",body)

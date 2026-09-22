extends Area2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collectedsound = $collectedsound
@onready var collision_shape_2d = $CollisionShape2D

signal collected

func _on_body_entered(_body):
	animated_sprite_2d.animation = "collected"
	collectedsound.play()
	collected.emit()
	call_deferred("_collision_disabled")

func _collision_disabled() -> void:
	collision_shape_2d.disabled = true


func _on_animated_sprite_2d_animation_looped():
	if animated_sprite_2d.animation == "collected":
		queue_free() # Replace with function body.

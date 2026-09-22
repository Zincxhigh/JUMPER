extends Node2D
@onready var score_label = $HUD/ScorePanel/ScoreLabel
@onready var fade = $HUD/fade


var level: int = 1
var score: int = 0
var current_level_root: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	fade.modulate.a = 1.0
	current_level_root = get_node("levelbuild")
	await _load_level(level, true, false)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _load_level(level_number: int, first_load: bool, reset_score: bool) -> void:
	if not first_load:
		await _fade(1.0)
	
	if reset_score:
		score = 0
		score_label.text = "Score: 0"
	if current_level_root:
		current_level_root.queue_free()

	var level_path = "res://scenes/levels/level%d.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "levelbuild"
	_setup_level(current_level_root)
	
	await _fade(0.0)
	
	
func _setup_level(levelbuild: Node) -> void:
	
	var exit = levelbuild.get_node_or_null("exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	
	var apples = levelbuild.get_node_or_null("apples")
	if apples:
		for apple in apples.get_children():
			apple.collected.connect(increase_score)
	
	var enemies = levelbuild.get_node_or_null("enemies")
	if enemies:
		for Enemy in enemies.get_children():
			Enemy.player_died.connect(_on_player_died)

func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		level += 1
		print(level)
		body.can_move = false
		await _load_level(level, false, true)


func _on_player_died(body):
	body.die()
	await _load_level(level, false, false)

func increase_score() -> void:
	score += 1
	score_label.text = "Score: %s" % score

func _fade(to_alpha: float) -> void:
	var tween = create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
	
		

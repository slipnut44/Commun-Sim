extends Node2D


# TODO: remove everything below when done testing base agent movement
func _ready():
	var resident_scene = preload("res://Scenes/Agents/resident_agent.tscn")
	var agent = resident_scene.instantiate()
	add_child(agent)
	agent.global_position = Vector2(100, 25)
	agent.move_to(Vector2i(500, 300))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

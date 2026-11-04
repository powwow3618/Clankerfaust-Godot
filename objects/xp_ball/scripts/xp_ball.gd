extends Area3D


var player: CharacterBody3D


func _process(delta: float) -> void:
	global_position = global_position.move_toward(player.global_position, 0.25)


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.currentXp += 1
		queue_free()

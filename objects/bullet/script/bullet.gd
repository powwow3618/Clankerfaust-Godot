extends RigidBody3D

var bulletLife: float = 5
var damage: int = 1

func _process(delta: float) -> void:
	bulletLife -= delta
	
	if bulletLife <= 0:
		queue_free()


func _on_colision(body: Node3D) -> void:
	if body is not RigidBody3D or body.name == "Player":
		queue_free()
		return
	
	body.health -= damage
	queue_free()

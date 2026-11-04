extends RigidBody3D


@onready var navigationAgent: NavigationAgent3D = $NavigationAgent3D
@onready var xpBallScene: PackedScene = load("res://objects/xp_ball/xp_ball.tscn")
@onready var deathParticleEmmiter: CPUParticles3D = $CPUParticles3D

var targetToFollow: CharacterBody3D
var speed: float = 4
var health: int = 3



func _process(delta: float) -> void:
	navigationAgent.target_position = targetToFollow.position
	
	if health <= 0:
		var deathCopy: CPUParticles3D = deathParticleEmmiter.duplicate()
		
		add_sibling(deathCopy)
		deathCopy.global_position = global_position
		deathCopy.emitting = true
		
		
		
		var xpBallCopy: Area3D = xpBallScene.instantiate()
		xpBallCopy.position = position
		xpBallCopy.player = targetToFollow
		add_sibling(xpBallCopy)
		
		get_parent().get_parent().currentSpawnedEnemies -= 1
		
		queue_free()
	
	var nextLocation = navigationAgent.get_next_path_position()
	var currentLocation = global_transform.origin
	var newVelocity = (nextLocation - currentLocation).normalized() * speed
	
	linear_velocity = linear_velocity.move_toward(newVelocity,0.25)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		body.health -= 1
		deathParticleEmmiter.emitting = true
		queue_free()

extends Node3D


@onready var enemyBasicScene:PackedScene = load("res://objects/enemies/enemy_basic/enemy_basic.tscn")

var spawnpointsLocations: Array = []
var maxWaveTimer: float = 6.0
var currentWaveTimer: float = maxWaveTimer
var currentSpawnedEnemies: int = 0
var enemiesToSpawn: int =  0
var waveScalling: float = 1.2
var currentWaveSize: int = 9
var currentWave: int = 0
var healthScale: float = 1
var speedScale: float = 1
var scanTime:float = 5.0
var scan:float = scanTime

func _ready() -> void:
	spawnpointsLocations = $SpawnPoints.get_children()

func _process(delta: float) -> void:
	scan += delta
	if currentSpawnedEnemies == 0:
		print("wave starting")
		currentWave += 1
		$Player.currentWave = currentWave
		healthScale *= waveScalling
		speedScale *= waveScalling
		enemiesToSpawn = currentWaveSize
		currentWaveSize *= waveScalling
		currentWaveTimer = maxWaveTimer
	

	if currentWaveTimer == maxWaveTimer:
		for i in range(currentWaveSize):
			print("spawning")
			var enemyCopy:RigidBody3D = enemyBasicScene.instantiate()
			enemyCopy.speed *= speedScale * randf_range(0.6,1.2)
			enemyCopy.health *= healthScale
			enemyCopy.position = spawnpointsLocations[randi_range(0,(spawnpointsLocations.size()-1))].global_position
			enemyCopy.targetToFollow = $Player
			$Enemies.add_child(enemyCopy)
			
			enemiesToSpawn -= 1
			currentSpawnedEnemies += 1
			
		currentWaveTimer = maxWaveTimer
	
	$Player.enemiesAlive = currentSpawnedEnemies
	currentWaveTimer -= delta
	if scan >= scanTime:
		currentSpawnedEnemies = $Enemies.get_child_count()
		scan = 0

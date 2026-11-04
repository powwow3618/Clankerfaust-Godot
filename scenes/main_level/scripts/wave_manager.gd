extends Node3D


@onready var enemyBasicScene:PackedScene = load("res://objects/enemies/enemy_basic/enemy_basic.tscn")
@onready var enemySlimeScene: PackedScene = load("res://objects/enemies/enemy_slime/enemy_slime.tscn")
@onready var enemyBigScene: PackedScene = load("res://objects/enemies/enemy_big/enemy_big.tscn")

var enemiesList: Array = []

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
	enemiesList = [enemyBasicScene,enemySlimeScene,enemyBigScene]

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
			
			var enemyWeight: int = randi_range(0,enemiesList.size()-1)

			var enemyCopy:RigidBody3D = enemiesList[enemyWeight].instantiate()
			
			enemyCopy.speed *= speedScale * randf_range(0.6,1.2)
			enemyCopy.health *= healthScale

			var spawnPosition: Vector3 = spawnpointsLocations[randi_range(0,(spawnpointsLocations.size()-1))].global_position

			enemyCopy.position = spawnPosition * Vector3(randf_range(0.9,1.2),0,randf_range(0.9,1.2))
			enemyCopy.targetToFollow = $Player

			$Enemies.add_child(enemyCopy)
			
			enemiesToSpawn -= enemyWeight + 1
			currentSpawnedEnemies += enemyWeight + 1
			
		currentWaveTimer = maxWaveTimer
	
	$Player.enemiesAlive = currentSpawnedEnemies
	currentWaveTimer -= delta
	if scan >= scanTime:
		currentSpawnedEnemies = $Enemies.get_child_count()
		scan = 0

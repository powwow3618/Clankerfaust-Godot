extends CharacterBody3D



var currentXp: int = 0
var currentWave: int = 0
var enemiesAlive: int = 0
var maxXp: int = 3
const RAY_LENGTH: int = 100

var upgradesList: Array = ["Speed", "Max Health", "Bullet Damage", "Bullet Speed", "Firing Speed"]

var speed: float = 10.0
var maxHealth: int = 5
var health: int = maxHealth
var bulletDamage: int = 1
var bulletSpeed: int = 20
var fireDelay:float = 0.65
var fireDelayTimer:float = fireDelay

@onready var gunPivot:Node3D = $GunPivot
@onready var gunBulletSpawn:Node3D = $GunPivot/Node3D
@onready var progressBarXp: TextureProgressBar = $CanvasLayer/ProgressBar
@onready var upgradeContainer: HBoxContainer = $CanvasLayer/UpgradeContainer
@onready var particleEmmiter: CPUParticles3D = $CPUParticles3D
@onready var labelMaxHealth: Label = $CanvasLayer/MaxHealth
@onready var labelCurrentHealth: Label = $CanvasLayer/CurrentHealth
@onready var labelCurrentWave: Label = $CanvasLayer/CurrentWave
@onready var labelEnemiesAlive: Label =$CanvasLayer/CurrentWave/EnemiesAlive
@onready var bulletScene:PackedScene = load("res://objects/bullet/bullet.tscn")
@onready var upgradeCardScene: PackedScene = load("res://objects/upgrade_card/upgrade_card.tscn")


func _ready() -> void:
	labelMaxHealth.text = str(maxHealth)

func _physics_process(delta: float) -> void:
	
	if health == 0:
		get_tree().paused = true
		
	if Input.is_action_pressed("shoot") and fireDelayTimer >= fireDelay:
		
		var bulletCopy:RigidBody3D = bulletScene.instantiate()
		bulletCopy.damage = bulletDamage
		bulletCopy.position = gunBulletSpawn.global_position
		bulletCopy.transform.basis = gunBulletSpawn.global_transform.basis
		bulletCopy.linear_velocity = bulletCopy.transform.basis * Vector3.FORWARD * bulletSpeed
		get_parent().add_child(bulletCopy)
		
		fireDelayTimer = 0
	
	elif fireDelayTimer <= fireDelay:
		fireDelayTimer += delta
		
	
	
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		particleEmmiter.emitting = true
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		particleEmmiter.emitting = false
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	if currentXp == maxXp:
		level_up()
	
	labelEnemiesAlive.text = str(enemiesAlive)
	labelCurrentWave.text = str(currentWave)
	labelCurrentHealth.text = str(health)
	labelMaxHealth.text = str(maxHealth)
	progressBarXp.value = currentXp
	move_and_slide()

func level_up():
	get_tree().paused = true
	
	var temp: Array = []
	
	while true:
		
		var index: int = randi_range(0,(upgradesList.size()-1))
		if upgradesList[index] in temp:
			continue
		
		temp.append(upgradesList[index])
		
		
		var upgradeCardCopy:Button = upgradeCardScene.instantiate()
		
		upgradeCardCopy.upgradeToDisplay = upgradesList[index]
		upgradeCardCopy.player = self
		
		upgradeContainer.add_child(upgradeCardCopy)
		if temp.size() == 3:
			break
	
	maxXp *= 1.5
	progressBarXp.max_value = maxXp
	currentXp = 0

func _input(event: InputEvent) -> void:
	if InputEventMouseMotion:
		gunPivot.look_at(Vector3(get_raycast_position().x,position.y,get_raycast_position().z))
	

func get_raycast_position():
	var space_state = get_world_3d().direct_space_state
	var cam = get_viewport().get_camera_3d()
	var mousepos = get_viewport().get_mouse_position()
	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)

	return result.get("position", null)

extends Button


var upgradeToDisplay: String = "None"
var player: CharacterBody3D

func _ready() -> void:
	$Label.text = upgradeToDisplay

func _process(delta: float) -> void:
	pass
	if get_tree().paused == false:
		queue_free()

func _on_pressed() -> void:
	print("PRESS")
	match upgradeToDisplay:
		"Speed":
			player.speed *= 1.2
		"Max Health":
			var healthToAdd = player.maxHealth * 1.5
			player.maxHealth += healthToAdd
			player.health += healthToAdd
		"Bullet Damage":
			player.bulletDamage += 1
		"Bullet Speed":
			player.bulletSpeed *= 1.2
		"Firing Speed":
			player.fireDelay *= 0.8
			
	get_tree().paused = false

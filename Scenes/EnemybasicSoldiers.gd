extends KinematicBody

onready var nav = get_tree().get_nodes_in_group("NavMesh")[0]
onready var player = get_tree().get_nodes_in_group("Player")[0]

var path = [] #hold the path coordinates from the enemy to the player 
var path_index = 0 #keep track of which coordinate to go to 
var speed = 6
var health = 20
var move = true

var searching = false
onready var ray = $Visual

func _ready():
	pass
	
func take_damage(dmg_amount):
	health -= dmg_amount
	if health <= 0:
		death()
		return
	move = false
	$AnimatedSprite3D.play("Hit")
	yield($AnimatedSprite3D,"animation_finished")
	$AnimatedSprite3D.play("Walking")
	move = true
	
func _physics_process(delta):
	if searching:
		if path_index < path.size():
			var direction = (path[path_index] - global_transform.origin)
			if direction.length() < 1:
				path_index += 1
			else:
				if move:
					move_and_slide(direction.normalized() * speed, Vector3.UP)
	else:
		$AnimatedSprite3D.play("idle")
		
func look_at_player():
	ray.look_at(player.global_transform.origin)
	if ray.is_colliding():
		if ray.collider().is_in_group("Player"):
			searching = true
			print("I see you")
		else:
			searching = false
			var check_near = $Aural.get_overlapping_bodies()
			for body in check_near:
				if body.is_in_group("Player"):
					searching = true
		
		
		
func find_path(target):
	path =nav.get_simple_path(global_transform.origin,target)
	path_index = 0
	
func death():
	set_process(false)
	set_physics_process(false)
	$CollisionShape.disabled = true
	yield($AnimatedSprite3D,"animation_finished")
	if health < -20:
		$AnimatedSprite3D.play("Explode")
	else:
		$AnimatedSprite3D.play("Die")
	
func shoot(target):
	pass


func _on_Timer_timeout():
	find_path(player.global_transform.origin)


func _on_Aural_body_entered(body):
	if body.is_in_group("Player"):
		print("I hear you")
		searching = true

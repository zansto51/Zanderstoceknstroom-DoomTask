extends Spatial

onready var gun_sprite = $CanvasLayer/Control/GunSprite
onready var gun_array = $GunRays.get_children()
onready var flash


func _ready():
	gun_sprite.play("idle")
	
func check_hit():
	pass
	
func make_flash():
	pass
	
func _process(delta):
	if input.is_action_just_pressed("shoot")

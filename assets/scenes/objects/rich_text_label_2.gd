extends RichTextLabel

var player

func _ready():
	player = get_node("/root/Player")
	set_process(true)

func _process(delta):
	var vel = $"..".velocity.y
	var velocity_text = "VelocityY: " + str(vel)
	text = velocity_text

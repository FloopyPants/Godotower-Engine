extends RichTextLabel

var player

func _ready():
	player = get_node("/root/Player")
	set_process(true)

func _process(delta):
	var stats = $"..".state
	text = str(stats)

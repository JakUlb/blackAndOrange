extends ParallaxBackground

var motion = 20

func _process(delta):
	scroll_offset.x -= motion * delta

extends Sprite2D

func set_sprite(frames: SpriteFrames):
	$Sprite.sprite_frames = frames

func hover() -> void:
	texture = load("res://assets/battle/InfoBarSelect.png")
	
func unhover() -> void:
	texture = load("res://assets/battle/InfoBar.png")
	

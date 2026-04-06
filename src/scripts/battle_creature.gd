extends AnimatedSprite2D

var creature : CreatureResource

func create(battler : CreatureResource, is_player : bool = false) -> void:
	creature = battler
	if is_player:
		sprite_frames.add_frame("default",creature.species.back_sprite)
	else:
		sprite_frames.add_frame("default",creature.species.sprite)

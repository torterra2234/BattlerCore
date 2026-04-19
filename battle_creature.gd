extends Node2D

var creature : CreatureResource
var healthbar_len : int

##sets layout from template file and add creature
func setup(resource : String, battler : CreatureResource) -> void:
	var template : BattleTemplate = load("res://data/templates/"+resource+".tres")
	creature = battler
	$Sprite.position = template.sprite_pos
	$Sprite.sprite_frames = creature.get_battle_sprites()
	$InfoBar.position = template.box_pos
	$InfoBar/Name.text = creature.get_nickname()
	$InfoBar/Lvl.text = "Lvl "+str(creature.level)
	$InfoBar/HP.text = str(creature.curr_hp) +"/"+ str(creature.max_hp)
	healthbar_len = template.healthbar_len
	$InfoBar/Healthbar.size.x = healthbar_len
	
func update_health(new_health : int) -> void:
	$InfoBar/HP.text = str(new_health) +"/"+ str(creature.max_hp)
	$InfoBar/Healthbar.size.x = ceili(healthbar_len*new_health/creature.max_hp)
	creature.curr_hp = new_health
	
func apply_dmg(dmg : int) -> bool:
	var faint := false
	var old_hp : int = creature.curr_hp
	if dmg >= old_hp:
		faint = true
		dmg = old_hp
	update_health(old_hp-dmg)
	print(creature.curr_hp)
	return faint
	

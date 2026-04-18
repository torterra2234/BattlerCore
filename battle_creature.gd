extends Node2D

var creature : CreatureResource
var healthbar_len : int

##sets layout from template file and add creature
func setup(resource : String, creature : CreatureResource) -> void:
	var template : BattleTemplate = load("res://data/templates/"+resource+".tres")
	creature = creature
	$Sprite.position = template.sprite_pos
	$InfoBar.position = template.box_pos
	$InfoBar/Name.text = creature.get_nickname()
	$InfoBar/Lvl.text = "Lvl "+str(creature.level)
	$InfoBar/HP.text = str(creature.curr_hp) +"/"+ str(creature.max_hp)
	healthbar_len = template.healthbar_len
	$InfoBar/Healthbar.size.x = healthbar_len
	
func update_health(new_health : int) -> void:
	$InfoBar/HP.text = str(new_health) +"/"+ str(creature.max_hp)
	$InfoBar/Healthbar.size.x = ceili(new_health/creature.max_hp)
	
	

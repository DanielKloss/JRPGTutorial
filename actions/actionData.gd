class_name ActionData extends Resource

enum elements {NONE, CODE, DESIGN, ART, BUG}

@export var icon: Texture
@export var label := "Base Combat Action"
@export var energyCost := 0
@export var element := elements.NONE
@export var isTargettingSelf := false
@export var isTargettingAll := false
@export var readinessSaved := 0.0

func canBeUsedBy(battler) -> bool:
	return energyCost <= battler.stats.energy


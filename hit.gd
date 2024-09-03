class_name Hit extends RefCounted

var hitDamage := 0
var hitChance : float

func _init(damage: int, chance := 100.0) -> void:
	hitDamage = damage
	hitChance = chance

func doesHit() -> bool:
	return randf() * 100.0 < hitChance

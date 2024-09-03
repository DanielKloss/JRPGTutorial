class_name Formulas extends RefCounted

static func calculatePotentialDamage(actionData: ActionData, attacker: Battler) -> float:
	print(attacker.stats.attack)
	return attacker.stats.attack * actionData.damageMultiplier
	
static func calculateWeaknessMultiplier(actionData: ActionData, defender: Battler) -> float:
	var multiplier := 1.0
	var element: int = actionData.element
	if element != Types.elements.NONE:
		if Types.weaknessMapping[defender.stats.affinity] == element:
			multiplier = 0.75
		elif Types.weaknessMapping[element] in defender.stats.weaknesses:
			multiplier = 1.5
	return multiplier
	
static func calculateBaseDamage(actionData: ActionData, attacker: Battler, defender: Battler) -> float:
	var damage: float = calculatePotentialDamage(actionData, attacker)
	damage -= defender.stats.defense
	damage *= calculateWeaknessMultiplier(actionData, defender)
	return int(clamp(damage, 1.0, 999.0))

static func calculateHitChance(actionData: ActionData, attacker: Battler, defender: Battler) -> float:
	var chance: float = attacker.stats.hitChance - defender.stats.evasion
	chance *= actionData.hitChance / 100.0
	var element: int = actionData.element
	if element == attacker.stats.affinity:
		chance += 5.0
	if element != Types.elements.NONE:
		if Types.weaknessMapping[element] in defender.stats.weaknesses:
			chance += 10.0
		if Types.weaknessMapping[defender.stats.affinity] == element:
			chance -= 10.0
	return clamp(chance, 0.0, 100.0) 

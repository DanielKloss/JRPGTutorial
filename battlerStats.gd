class_name BattlerStats extends Resource

signal healthDepleated
signal healthChanged(oldValue, newValue)
signal energyChanged(oldValue, newValue)

const upgradableStats = ["maxHeatlh", "maxEnergy", "attack", "defense", "speed", "hitChance", "evasion"]

@export var maxHealth := 100.0
@export var maxEnergy := 6
@export var baseAttack : int : set = setBaseAttack
@export var baseDefense := 10.0 : set = setBaseDefense
@export var baseSpeed := 70.0 : set = setBaseSpeed
@export var baseHitChance := 100.0 : set = setBaseHitChance
@export var baseEvasion := 0.0 : set = setBaseEvasion
@export var affinity : Types.elements = Types.elements.NONE
@export var weaknessness := []

var attack := baseAttack
var defense := baseDefense
var speed := baseSpeed
var hitChance := baseHitChance
var evasion := baseEvasion

var health := maxHealth : set = setHealth
var energy := 0 : set = setEnergy

var modifiers := {
	"percentage" : {},
	"value" : {}
}

func _init() -> void:
	for stat in upgradableStats:
		modifiers[stat] = {}

func reinitialise() -> void:
	setHealth(maxHealth)
	
func setHealth(value: float) -> void:
	var previousHealth := health
	health = clamp(value, 0.0, maxHealth)
	emit_signal("healthChanged", previousHealth, health)
	if is_equal_approx(health, 0.0):
		emit_signal("healthDepleated")
		
func setEnergy(value: float) -> void:
	var previousEnergy := energy
	energy = int(clamp(value, 0.0, maxEnergy))
	emit_signal("energyChanged", previousEnergy, energy)
	
func setBaseAttack(value: float) -> void:
	baseAttack = value
	recalculateAndUpdate("Attack")

func setBaseDefense(value: float) -> void:
	baseDefense = value
	recalculateAndUpdate("Defense")

func setBaseSpeed(value: float) -> void:
	baseSpeed = value
	recalculateAndUpdate("Speed")

func setBaseHitChance(value: float) -> void:
	baseHitChance = value
	recalculateAndUpdate("HitChance")

func setBaseEvasion(value: float) -> void:
	baseEvasion = value
	recalculateAndUpdate("Evasion")

func recalculateAndUpdate(stat: String):
	var value: float = get("base" + stat)
	var percentageModifiers: Array = modifiers["percentage"].values()
	var totalPercentage := 0
	for modifier in percentageModifiers:
		totalPercentage += modifier
	value = max(totalPercentage*value, 0.0)
	set(stat, value)
	
	var valueModifiers: Array = modifiers["value"].values()
	for modifier in valueModifiers:
		value += modifier
	value = max(value, 0.0)
	set(stat, value)
	
func addModifier(statName: String, modifierId: int, type: String, value: float) -> void:
	if statName not in upgradableStats:
		return
	
	modifiers[statName][type][modifierId] = value
	recalculateAndUpdate(statName)
		
func removeModifier(statName: String, type: String, id: int) -> void:
	if statName not in upgradableStats:
		return
		
	modifiers[statName][type].erase(id)
	recalculateAndUpdate(statName)

class_name BattlerStats extends Resource

signal healthDepleated
signal healthChanged(oldValue, newValue)
signal energyChanged(oldValue, newValue)

@export var maxHealth := 100.0
@export var maxEnergy := 6
@export var baseAttack := 10.0 : set = setBaseAttack
@export var baseDefense := 10.0 : set = setBaseDefense
@export var baseSpeed := 70.0 : set = setBaseSpeed
@export var baseHitChance := 100.0 : set = setBaseHitChance
@export var baseEvasion := 0.0 : set = setBaseEvasion

var attack := baseAttack
var defense := baseDefense
var speed := baseSpeed
var hitChance := baseHitChance
var evasion := baseEvasion

var health := maxHealth : set = setHealth
var energy := 0 : set = setEnergy

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
	recalculateAndUpdate("attack")

func setBaseDefense(value: float) -> void:
	baseDefense = value
	recalculateAndUpdate("defense")

func setBaseSpeed(value: float) -> void:
	baseSpeed = value
	recalculateAndUpdate("speed")

func setBaseHitChance(value: float) -> void:
	baseHitChance = value
	recalculateAndUpdate("hitChance")

func setBaseEvasion(value: float) -> void:
	baseEvasion = value
	recalculateAndUpdate("evasion")

func recalculateAndUpdate(stat: String):
	pass

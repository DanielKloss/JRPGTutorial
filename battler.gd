class_name Battler extends Node2D

signal readyToAct
signal readinessChanged(value)
signal selectionToggled(value)
signal damageTaken(amount)
signal hitMissed
signal actionFinished

@export var stats: Resource
@export var aiScene: PackedScene
@export var actions: Array
@export var isPartyMember:= false

var timeScale := 1.0 : set = setTimeScale
var readiness := 0.0 : set = setReadiness
var isActive := true : set = setIsActive
var isSelected := false : set = setIsSelected
var isSelectable := true : set = setIsSelectable

func _ready() -> void:
	stats = stats.duplicate()
	stats.reinitialise()
	stats.healthDepleated.connect(onBattlerStatsHealthDepleated)

func _process(delta: float) -> void:
	setReadiness(readiness + stats.speed * delta * timeScale)
	
func setTimeScale(value: float) -> void:
	timeScale = value
	
func setReadiness(value: float) -> void:
	readiness = value
	emit_signal("readinessChanged", readiness)
	
	if readiness >= 100.0:
		emit_signal("readyToAct")
		set_process(false)
		
func setIsActive(value: bool) -> void:
	isActive = value
	set_process(isActive)
	
func setIsSelected(value: bool) -> void:
	if isSelectable == false:
		return
	isSelected = value
	emit_signal("selectionToggled")

func setIsSelectable(value: bool) -> void:
	isSelectable = value
	if isSelectable == false:
		isSelected = false
		
func isPlayerControlled() -> bool:
	return aiScene == null

func act(action: Action) -> void:
	stats.energy -= action.data.energyCost
	await action.applyAsync()
	setReadiness(action.data.readinessSaved)
	if isActive:
		set_process(true)
	emit_signal("actionFinished")

func takeHit(hit: Hit) -> void:
	if hit.doesHit():
		takeDamage(hit.hitDamage)
		emit_signal("damageTaken")
	else:
		emit_signal("hitMissed")
		
func takeDamage(amount: int) -> void:
	stats.health -= amount
	print("%s took %s damage. Health is now %s." % [name, amount, stats.health])

func onBattlerStatsHealthDepleated() -> void:
	setIsActive(false)
	if not isPartyMember:
		setIsSelectable(false)

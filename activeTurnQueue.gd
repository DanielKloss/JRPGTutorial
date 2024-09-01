class_name ActiveTurnQueue extends Node2D

var partyMembers := []
var opponents := []
var isActive := true : set = setIsActive
var timeScale := 1.0 : set = setTimeScale

@onready var battlers := get_children()

func _ready() -> void:
	for battler in battlers:
		battler.readyToAct.connect(onBattlerReadyToAct, [battler])
		if battler.isPartyMember:
			partyMembers.append(battler)
		else:
			opponents.append(battler)
			
func onBattlerReadyToAct(battler: Battler) -> void:
	playTurn(battler)
	
func playTurn(battler: Battler) -> void:
	var actionData: ActionData
	var targets := []
	
	battler.stats.energy += 1
	var potentialTargets := []
	
	var opponents := opponents if battler.isPartyMember else partyMembers
	for opponent in opponents:
		if opponent.isSelectable:
			potentialTargets.append(opponent)
			
	if battler.isPlayerControlled():
		battler.isSelected = true
		setTimeScale(0.05)
		
		var isSelectionComplete := false
		while not isSelectionComplete:
			actionData = await playerSelectActionAsync(battler)
			if actionData.isTragettingSelf:
				targets = [battler]
			else:
				targets = await playerSelectTargetsAsync(actionData, potentialTargets)
			isSelectionComplete = actionData != null && targets != []
		setTimeScale(1.0)
		battler.isSelected = false
	else:
		actionData = battler.action[0]
		targets = [potentialTargets[0]]
		
func playerSelectActionAsync(battler: Battler) -> ActionData:
	await get_tree().process_frame
	return battler.actions[0]
	
func playerSelectTargetsAsync(action: ActionData, opponents: Array) -> Array:
	await get_tree().process_frame
	return [opponents[0]]

func setIsActive(value: bool) -> void:
	isActive = value
	for battler in battlers:
		battler.isActive = isActive

func setTimeScale(value: float) -> void:
	timeScale = value
	for battler in battlers:
		battler.timeScale = timeScale

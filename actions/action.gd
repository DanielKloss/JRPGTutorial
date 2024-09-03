class_name Action extends RefCounted

signal finsihed

var data: ActionData
var actor
var targets := []

func _init(actionData: ActionData, actionActor, actionTargets: Array) -> void:
	data = actionData
	actor = actionActor
	targets = actionTargets

func applyAsync() -> bool:
	await Engine.get_main_loop()
	emit_signal("finsihed")
	return true

func targetsOpponents() -> bool:
	return true

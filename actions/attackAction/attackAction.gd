class_name AttackAction extends Action

var hits = []

func _init(data: AttackActionData, actor, targets: Array) -> void:
	super(data, actor, targets)
	pass

func calculatePotentialDamageFor(target) -> int:
	return Formulas.calculateBaseDamage(data, actor,target)
	
func applyAsync() -> bool:
	for target in targets:
		var hitChance := Formulas.calculateHitChance(data, actor, target)
		var damage := calculatePotentialDamageFor(target)
		var hit := Hit.new(damage, hitChance)
		target.takeHit(hit)
	await Engine.get_main_loop()
	return true

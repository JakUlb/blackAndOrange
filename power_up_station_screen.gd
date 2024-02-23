extends Control
var maxHealthBaseCost : int = Global.max_health/6
var maxHealthCost : int
var healthDropProbabilityBaseCost : int = 20
var healthDropProbabilityCost : int
var healthDropAmountBaseCost : int = 10
var healthDropAmountCost : int 
var movingSpeedBaseCost : int = 10
var movingSpeedCost : int
var attackSpeedBaseCost : int = 10
var	attackSpeedCost : int
var attackDamageBaseCost : int = 10
var attackDamageCost : int
var maxHealthModifier : int = 10
var healthDropProbabilityModifier : int = 1
var healthDropAmountModifier : int = 1
var movingSpeedModifier : int = 10
var attackSpeedModifier : float = 0.1
var attackDamageModifier : int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateMaxHealthUI()
	updateHealthDropProbabilityUI()
	updateHealthDropAmountUI()
	updateMovingSpeedUI()
	updateAttackSpeedUI()
	updateAttackDamageUI()

func _on_max_health_upgrade_pressed():
	Global.max_health += calculateBoost(Global.maxHealthUpgrades,maxHealthModifier)
	Global.maxHealthUpgrades+=1
	Global.health -= maxHealthCost
	
func _on_healthdrop_probability_upgrade_pressed():
	Global.healthDropProbability -= 1
	Global.healthDropProbabilityUpgrades+=1
	Global.health -= healthDropProbabilityCost

func _on_health_drop_amount_upgrade_pressed():
	Global.healthDropAmount += calculateBoost(Global.healthDropAmountUpgrades,healthDropAmountModifier)
	Global.healthDropAmountUpgrades += 1
	Global.health -= healthDropAmountCost

func _on_moving_speed_upgrade_pressed():
	Global.speed += calculateBoost(Global.movingSpeedUpgrades,movingSpeedModifier)
	Global.movingSpeedUpgrades += 1
	Global.health -= movingSpeedCost
	
func _on_attack_speed_upgrade_pressed():
	Global.attackCooldown -= calculateBoost(Global.attackSpeedUpgrades,attackSpeedModifier)
	Global.attackSpeedUpgrades += 1
	Global.health -= attackSpeedCost
	
func _on_attack_damage_upgrade_pressed():
	Global.cat_attack_damage += calculateBoost(Global.attackDamageUpgrades,attackDamageModifier)
	Global.attackDamageUpgrades += 1
	Global.health -= attackDamageCost
	
func _on_exit_shop_pressed():
	Global.cat_attacking=false
	Global.shopOpen=false
	Global.wave_cleared=false
	Global.health+=20
	get_tree().change_scene_to_file("res://main.tscn")

func calculateCost(upgradeAmount,basePrice):
	return basePrice*(1+upgradeAmount)

func calculateBoost(upgradeAmount,modifier):
	return modifier*upgradeAmount

func updateMaxHealthUI():
	maxHealthCost =calculateCost(Global.maxHealthUpgrades,maxHealthBaseCost)
	var upgradeBoost =calculateBoost(Global.maxHealthUpgrades,maxHealthModifier)
	if canNotAfford(maxHealthCost):
		$MarginContainer3/PowerUps/HBoxContainer/MaxHealthBox/MaxHealthUpgrade.disabled=true
	$MarginContainer3/PowerUps/HBoxContainer/MaxHealthBox/MaxHealthUpgrade.text = "Max Health +%s" %upgradeBoost
	$MarginContainer3/PowerUps/HBoxContainer/MaxHealthBox/MaxHealthCost.text = "Cost: %s" %maxHealthCost
	$MarginContainer3/PowerUps/HBoxContainer/MaxHealthBox/CurrentMaxHealth.text = "Current Max Health: %s" %Global.max_health
	
func updateHealthDropProbabilityUI():
	if Global.healthDropProbability > 1:
		var healthDropProbabilityValuePercent = ((1/(float(Global.healthDropProbability)))*100)
		var currentProbability = (1/float(Global.healthDropProbability))
		var newProbability = (1/float(Global.healthDropProbability-1))
		var upgradeBoost = (newProbability-currentProbability)*100
		healthDropProbabilityCost = calculateCost(Global.healthDropProbabilityUpgrades,healthDropProbabilityBaseCost)
		if canNotAfford(healthDropProbabilityCost):
			$MarginContainer3/PowerUps/HBoxContainer/HealthDropProbabilityBox/HealthdropProbabilityUpgrade.disabled=true
		$MarginContainer3/PowerUps/HBoxContainer/HealthDropProbabilityBox/HealthdropProbabilityUpgrade.text = "Probability of Healthdrop +%s%%" %upgradeBoost
		$MarginContainer3/PowerUps/HBoxContainer/HealthDropProbabilityBox/HealthDropProbabilityCost.text = "Cost: %s" %healthDropProbabilityCost
		$MarginContainer3/PowerUps/HBoxContainer/HealthDropProbabilityBox/CurrentHealthDropProbability.text = "Current Probability: %s%%" %healthDropProbabilityValuePercent
	else:
		$MarginContainer3/PowerUps/HBoxContainer/HealthDropProbabilityBox/HealthdropProbabilityUpgrade.disabled=true
		$MarginContainer3/PowerUps/HBoxContainer/HealthDropProbabilityBox/HealthdropProbabilityUpgrade.text = "MAX"
		$MarginContainer3/PowerUps/HBoxContainer/HealthDropProbabilityBox/HealthDropProbabilityCost.text = "not available" 
		$MarginContainer3/PowerUps/HBoxContainer/HealthDropProbabilityBox/CurrentHealthDropProbability.text = "Current Probability: 100%"
	
func updateHealthDropAmountUI():
	healthDropAmountCost =calculateCost(Global.healthDropAmountUpgrades,healthDropAmountBaseCost)
	var upgradeBoost =calculateBoost(Global.healthDropAmountUpgrades,healthDropAmountModifier)
	if canNotAfford(healthDropAmountCost):
		$MarginContainer3/PowerUps/HBoxContainer/HealthDropAmountBox/HealthDropAmountUpgrade.disabled=true
	$MarginContainer3/PowerUps/HBoxContainer/HealthDropAmountBox/HealthDropAmountUpgrade.text = "Capacity of Healthdrop: +%s" %upgradeBoost
	$MarginContainer3/PowerUps/HBoxContainer/HealthDropAmountBox/HealthdropAmountCost.text = "Cost: %s" %healthDropAmountCost
	$MarginContainer3/PowerUps/HBoxContainer/HealthDropAmountBox/CurrentHealthDropAmount.text = "Current Capacity: %s" %Global.healthDropAmount
	
func updateMovingSpeedUI():
	movingSpeedCost =calculateCost(Global.movingSpeedUpgrades,movingSpeedBaseCost)
	var upgradeBoost =calculateBoost(Global.movingSpeedUpgrades,movingSpeedModifier)
	if canNotAfford(movingSpeedCost):
		$MarginContainer3/PowerUps/HBoxContainer/MovingSpeedBox/MovingSpeedUpgrade.disabled=true
	$MarginContainer3/PowerUps/HBoxContainer/MovingSpeedBox/MovingSpeedUpgrade.text = "Movement Speed + %s" %upgradeBoost
	$MarginContainer3/PowerUps/HBoxContainer/MovingSpeedBox/MovingSpeedCost.text = "Cost: %s" %movingSpeedCost
	$MarginContainer3/PowerUps/HBoxContainer/MovingSpeedBox/CurrentMovingSpeed.text = "Current Speed: %s" %Global.speed
	
func updateAttackSpeedUI():
	attackSpeedCost =calculateCost(Global.attackSpeedUpgrades,attackSpeedBaseCost)
	var attackSpeedUIvalue = 1/Global.attackCooldown
	var upgradeBoost =calculateBoost(Global.attackSpeedUpgrades,attackSpeedModifier)
	if canNotAfford(attackSpeedCost) or Global.attackCooldown <= 0.2:
		$MarginContainer3/PowerUps/HBoxContainer/AttackSpeedBox/AttackSpeedUpgrade.disabled=true
	$MarginContainer3/PowerUps/HBoxContainer/AttackSpeedBox/AttackSpeedUpgrade.text = "Attackspeed + %s" %upgradeBoost
	$MarginContainer3/PowerUps/HBoxContainer/AttackSpeedBox/AttackSpeedCost.text = "Cost: %s" %attackSpeedCost
	$MarginContainer3/PowerUps/HBoxContainer/AttackSpeedBox/CurrentAttackSpeed.text = "Current Speed: %s/sec" %attackSpeedUIvalue

func updateAttackDamageUI():
	attackDamageCost =calculateCost(Global.attackDamageUpgrades,attackDamageBaseCost)
	var upgradeBoost =calculateBoost(Global.attackDamageUpgrades,attackDamageModifier)
	if canNotAfford(attackDamageCost):
		$MarginContainer3/PowerUps/HBoxContainer/AttackDamageBox/AttackDamageUpgrade.disabled=true
	$MarginContainer3/PowerUps/HBoxContainer/AttackDamageBox/AttackDamageUpgrade.text = "Attack damage + %s" %upgradeBoost
	$MarginContainer3/PowerUps/HBoxContainer/AttackDamageBox/AttackDamageCost.text = "Cost: %s" %attackDamageCost
	$MarginContainer3/PowerUps/HBoxContainer/AttackDamageBox/CurrentAttackDamage.text = "Current attack damage: %s" %Global.cat_attack_damage

func canNotAfford(upgradeCost) -> bool:
	return upgradeCost >= Global.health

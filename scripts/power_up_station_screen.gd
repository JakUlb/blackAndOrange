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
	$HUD/CanvasLayer/MarginContainerAttack.hide()
	$"HUD/CanvasLayer/Virtual Joystick".hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateMaxHealthUI()
	updateHealthDropProbabilityUI()
	updateHealthDropAmountUI()
	updateMovingSpeedUI()
	updateAttackSpeedUI()
	updateAttackDamageUI()


func _on_max_health_button_pressed():
	Global.max_health += calculateBoost(Global.maxHealthUpgrades,maxHealthModifier)
	Global.maxHealthUpgrades+=1
	Global.health -= maxHealthCost
	$ClickSound.play()
	
func _on_max_health_info_button_pressed():
	changeLabelVisibility("MarginContainer/VBoxContainer/HBoxContainer2/MaxHealthFrame/MarginContainer/MaxHealthInfoLabel")
	
func _on_luck_button_pressed():
	Global.healthDropProbability += 10
	Global.healthDropProbabilityUpgrades+=1
	Global.health -= healthDropProbabilityCost
	$ClickSound.play()
	
func _on_luck_info_button_pressed():
	changeLabelVisibility("MarginContainer/VBoxContainer/HBoxContainer/LuckFrame/MarginContainer/LuckInfoLabel")

func _on_regeneration_button_pressed():
	Global.healthDropAmount += calculateBoost(Global.healthDropAmountUpgrades,healthDropAmountModifier)
	Global.healthDropAmountUpgrades += 1
	Global.health -= healthDropAmountCost
	$ClickSound.play()
	
func _on_regeneration_info_button_pressed():
	changeLabelVisibility("MarginContainer/VBoxContainer/HBoxContainer/RegenerationFrame/MarginContainer/RegenerationInfoLabel")

func _on_movement_button_pressed():
	Global.speed += calculateBoost(Global.movingSpeedUpgrades,movingSpeedModifier)
	Global.movingSpeedUpgrades += 1
	Global.health -= movingSpeedCost
	$ClickSound.play()
	
func _on_movement_info_button_pressed():
	changeLabelVisibility("MarginContainer/VBoxContainer/HBoxContainer/MovementFrame/MarginContainer/MovementInfoLabel")

func _on_attack_speed_button_pressed():
	Global.attackCooldown -= calculateBoost(Global.attackSpeedUpgrades,attackSpeedModifier)
	Global.attackSpeedUpgrades += 1
	Global.health -= attackSpeedCost
	$ClickSound.play()
	
func _on_attack_speed_info_button_pressed():
	changeLabelVisibility("MarginContainer/VBoxContainer/HBoxContainer2/AttackSpeedFrame/MarginContainer/AttackSpeedInfoLabel")
	
func _on_damage_button_pressed():
	Global.cat_attack_damage += calculateBoost(Global.attackDamageUpgrades,attackDamageModifier)
	Global.attackDamageUpgrades += 1
	Global.health -= attackDamageCost
	$ClickSound.play()
	
func _on_damage_info_button_pressed():
	changeLabelVisibility("MarginContainer/VBoxContainer/HBoxContainer2/DamageFrame/MarginContainer/DamageInfoLabel")
	
func _on_exit_shop_pressed():
	Global.cat_attacking=false
	Global.shopOpen=false
	Global.wave_cleared=false
	Global.powerUpStationInitialSound=true
	if Global.health + 20 <= Global.max_health:
		Global.health+=20
	$ClickSound.play()
	get_tree().change_scene_to_file("res://main.tscn")

func calculateCost(upgradeAmount,basePrice):
	return basePrice*(1+upgradeAmount)

func calculateBoost(upgradeAmount,modifier):
	return modifier*upgradeAmount

func updateMaxHealthUI():
	maxHealthCost =calculateCost(Global.maxHealthUpgrades,maxHealthBaseCost)
	var upgradeBoost =calculateBoost(Global.maxHealthUpgrades,maxHealthModifier)
	if canNotAfford(maxHealthCost):
		$MarginContainer/VBoxContainer/HBoxContainer2/MaxHealthFrame/MaxHealthButton.disabled=true
	$MarginContainer/VBoxContainer/HBoxContainer2/MaxHealthFrame/MarginContainer/VBoxContainer/UpgradeAmount.text = "Increase +%s" %upgradeBoost
	$MarginContainer/VBoxContainer/HBoxContainer2/MaxHealthFrame/MarginContainer/VBoxContainer/UpgradeCost.text = "Cost: -%s Health" %maxHealthCost
	$MarginContainer/VBoxContainer/HBoxContainer2/MaxHealthFrame/MarginContainer/VBoxContainer/CurrentValue.text = "Current: %s" %Global.max_health
	
func updateHealthDropProbabilityUI():
	if Global.healthDropProbability < 100:
		var currentProbability = Global.healthDropProbability
		var upgradeBoost = 10
		var newProbability = currentProbability+upgradeBoost
		healthDropProbabilityCost = calculateCost(Global.healthDropProbabilityUpgrades,healthDropProbabilityBaseCost)
		if canNotAfford(healthDropProbabilityCost):
			$MarginContainer/VBoxContainer/HBoxContainer/LuckFrame/LuckButton.disabled=true
		$MarginContainer/VBoxContainer/HBoxContainer/LuckFrame/MarginContainer/VBoxContainer/UpgradeAmount.text = "Increase: +%s%%" %upgradeBoost
		$MarginContainer/VBoxContainer/HBoxContainer/LuckFrame/MarginContainer/VBoxContainer/UpgradeCost.text = "Cost: -%s Health" %healthDropProbabilityCost
		$MarginContainer/VBoxContainer/HBoxContainer/LuckFrame/MarginContainer/VBoxContainer/CurrentValue.text = "Current: %s%%" %currentProbability
	else:
		$MarginContainer/VBoxContainer/HBoxContainer/LuckFrame/LuckButton.disabled=true
		$MarginContainer/VBoxContainer/HBoxContainer/LuckFrame/MarginContainer/VBoxContainer/UpgradeAmount.text = "MAX"
		$MarginContainer/VBoxContainer/HBoxContainer/LuckFrame/MarginContainer/VBoxContainer/UpgradeCost.text = "not available" 
		$MarginContainer/VBoxContainer/HBoxContainer/LuckFrame/MarginContainer/VBoxContainer/CurrentValue.text = "Current: 100%"
	
func updateHealthDropAmountUI():
	healthDropAmountCost =calculateCost(Global.healthDropAmountUpgrades,healthDropAmountBaseCost)
	var upgradeBoost =calculateBoost(Global.healthDropAmountUpgrades,healthDropAmountModifier)
	if canNotAfford(healthDropAmountCost):
		$MarginContainer/VBoxContainer/HBoxContainer/RegenerationFrame/RegenerationButton.disabled=true
	$MarginContainer/VBoxContainer/HBoxContainer/RegenerationFrame/MarginContainer/VBoxContainer/UpgradeAmount.text = "Increase: +%s" %upgradeBoost
	$MarginContainer/VBoxContainer/HBoxContainer/RegenerationFrame/MarginContainer/VBoxContainer/UpgradeCost.text = "Cost: -%s Health" %healthDropAmountCost
	$MarginContainer/VBoxContainer/HBoxContainer/RegenerationFrame/MarginContainer/VBoxContainer/CurrentValue.text = "Current: %s" %Global.healthDropAmount
	
func updateMovingSpeedUI():
	movingSpeedCost =calculateCost(Global.movingSpeedUpgrades,movingSpeedBaseCost)
	var upgradeBoost =calculateBoost(Global.movingSpeedUpgrades,movingSpeedModifier)
	if canNotAfford(movingSpeedCost):
		$MarginContainer/VBoxContainer/HBoxContainer/MovementFrame/MovementButton.disabled=true
	$MarginContainer/VBoxContainer/HBoxContainer/MovementFrame/MarginContainer/VBoxContainer/UpgradeAmount.text = "Increase: + %s" %upgradeBoost
	$MarginContainer/VBoxContainer/HBoxContainer/MovementFrame/MarginContainer/VBoxContainer/UpgradeCost.text = "Cost: -%s Health" %movingSpeedCost
	$MarginContainer/VBoxContainer/HBoxContainer/MovementFrame/MarginContainer/VBoxContainer/CurrentValue.text = "Current: %s" %Global.speed
	
func updateAttackSpeedUI():
	attackSpeedCost =calculateCost(Global.attackSpeedUpgrades,attackSpeedBaseCost)
	var attackSpeedUIvalue = 1/Global.attackCooldown
	var upgradeBoost =calculateBoost(Global.attackSpeedUpgrades,attackSpeedModifier)
	if canNotAfford(attackSpeedCost) or Global.attackCooldown <= 0.2:
		$MarginContainer/VBoxContainer/HBoxContainer2/AttackSpeedFrame/AttackSpeedButton.disabled=true
	$MarginContainer/VBoxContainer/HBoxContainer2/AttackSpeedFrame/MarginContainer/VBoxContainer/UpgradeAmount.text = "Increase + %s" %upgradeBoost
	$MarginContainer/VBoxContainer/HBoxContainer2/AttackSpeedFrame/MarginContainer/VBoxContainer/UpgradeCost.text = "Cost: -%s Health" %attackSpeedCost
	$MarginContainer/VBoxContainer/HBoxContainer2/AttackSpeedFrame/MarginContainer/VBoxContainer/CurrentValue.text = "Current: %s/sec" %attackSpeedUIvalue

func updateAttackDamageUI():
	attackDamageCost =calculateCost(Global.attackDamageUpgrades,attackDamageBaseCost)
	var upgradeBoost =calculateBoost(Global.attackDamageUpgrades,attackDamageModifier)
	if canNotAfford(attackDamageCost):
		$MarginContainer/VBoxContainer/HBoxContainer2/DamageFrame/DamageButton.disabled=true
	$MarginContainer/VBoxContainer/HBoxContainer2/DamageFrame/MarginContainer/VBoxContainer/UpgradeAmount.text = "Increase + %s" %upgradeBoost
	$MarginContainer/VBoxContainer/HBoxContainer2/DamageFrame/MarginContainer/VBoxContainer/UpgradeCost.text = "Cost: -%s Health" %attackDamageCost
	$MarginContainer/VBoxContainer/HBoxContainer2/DamageFrame/MarginContainer/VBoxContainer/CurrentValue.text = "Current: %s" %Global.cat_attack_damage

func changeLabelVisibility(labelPath):
	var label = get_node(labelPath)
	if label:
		label.visible = !label.visible

func canNotAfford(upgradeCost) -> bool:
	return upgradeCost >= Global.health




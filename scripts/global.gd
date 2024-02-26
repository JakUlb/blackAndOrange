extends Node

var cat_attacking : bool = false
var attack_animation_done : bool = true
var cat_attack_damage : int = 10
var chosen_cat
enum catType {RONNY,LUDWIG}
var wave_cleared : bool = true
var speed : int = 400
var health : int
var max_health
var attackCooldown : float = 0.5
var healthDropAmount : int = 10
var healthDropProbability : int = 10
var knockBackPower: int = 30
var killCounter : int = 0
var waveCounter : int = 1
var showWaveBanner : bool 
var roundStarted : bool = false
var powerUpStationInitialSound : bool = true
var shopOpen=false
var maxHealthUpgrades : int = 1
var healthDropProbabilityUpgrades : int = 1
var healthDropAmountUpgrades : int = 1
var movingSpeedUpgrades : int = 1
var attackSpeedUpgrades : int = 1
var attackDamageUpgrades : int = 1

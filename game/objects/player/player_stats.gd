extends Resource
class_name PlayerStats

enum Upgrade {
	SPEED_UP,
	GOOP_UP,
	MAX_HP,
	FIRE_RATE_UP,
	PROJECTILE_SPEED_UP,
	PROJECTILE_SIZE_UP,
	PROJECTILE_HOMING_RANGE,
	PROJECTILE_HOMING_SPEED,
	PROJECTILE_BOUNCE,
}

const RARE_UPGRADES = [
	Upgrade.PROJECTILE_HOMING_RANGE,
	Upgrade.PROJECTILE_HOMING_SPEED,
	Upgrade.PROJECTILE_BOUNCE,
]

var upgrades: Array[Upgrade]

var max_hp: int = 5
var speed_mult: float = 1.0
var goop_mult: float = 1.0
var fire_rate_mult: float = 1.0
var projectile_speed_mult: float = 1.0
var projectile_size_mult: float = 1.0
var projectile_homing_radius: float = 0.0
var projectile_homing_speed_mult: float = 1.0
var projectile_bounce: int = 0

static func get_upgrade_icon(upgrade: Upgrade) -> Texture2D:
	match upgrade:
		Upgrade.SPEED_UP:
			return preload("res://objects/hud/icons/speed_up.png")
		Upgrade.GOOP_UP:
			return preload("res://objects/hud/icons/goop_up.png")
		Upgrade.MAX_HP:
			return preload("res://objects/hud/icons/hp_up.png")
	return preload("res://objects/hud/icons/default.png")

static func is_upgrade_rare(upgrade: Upgrade) -> bool:
	return upgrade in RARE_UPGRADES

func add_upgrade(upgrade: Upgrade) -> void:
	upgrades.append(upgrade)
	match upgrade:
		Upgrade.SPEED_UP:
			speed_mult *= 1.2
		Upgrade.GOOP_UP:
			goop_mult *= 1.2
		Upgrade.MAX_HP:
			max_hp += 1
		Upgrade.FIRE_RATE_UP:
			fire_rate_mult *= 1.2
		Upgrade.PROJECTILE_SPEED_UP:
			projectile_speed_mult *= 1.2
		Upgrade.PROJECTILE_SIZE_UP:
			projectile_size_mult *= 1.2
		Upgrade.PROJECTILE_HOMING_RANGE:
			if projectile_homing_radius == 0.0:
				projectile_homing_radius = 26.0
			else:
				projectile_homing_radius *= 1.2
		Upgrade.PROJECTILE_HOMING_SPEED:
			projectile_homing_speed_mult *= 1.2
		Upgrade.PROJECTILE_BOUNCE:
			projectile_bounce += 1

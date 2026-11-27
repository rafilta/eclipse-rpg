extends CharacterBody2D

class_name Enemy

var multiplayer_connection: MultiplayerConnection = null

var entity_type: J.ENTITY_TYPE = J.ENTITY_TYPE.ENEMY
var enemy_class: String = ""
var component_list: Dictionary = {}

@onready var spawn_position: Vector2 = position

@onready var stats: StatsSynchronizerComponent = $StatsSynchronizerComponent
@onready var hurtbox: Area2D = $HurtArea
@onready var position_synchronizer: PositionSynchronizerComponent = $PositionSynchronizerComponent
@onready var lag_compensation: Node2D = $LagCompensationComponent


func _init():
	collision_layer = J.PHYSICS_LAYER_ENEMIES

	multiplayer_connection = J.server_client_multiplayer_connection

	if multiplayer_connection.is_server():
		# Enemies can be blocked by NPCs and players.
		collision_mask = J.PHYSICS_LAYER_WORLD + J.PHYSICS_LAYER_PLAYERS + J.PHYSICS_LAYER_NPCS
	else:
		# Don't handle collision on client side
		collision_mask = 0


func _ready():
	# Make sure to set the layer to enemies
	hurtbox.collision_layer = J.PHYSICS_LAYER_ENEMIES
	# We're not interested in others
	hurtbox.collision_mask = 0
	if multiplayer_connection.is_server():
		var drops := get_node_or_null("LootComponent") as LootComponent
		if drops == null:
			drops = LootComponent.new()
			drops.name = "EclipseLoot"
			drops.stats = stats
			add_child(drops)
		var hard: bool = enemy_class in ["WildBoar", "BlueMole"]
		drops.add_item_to_loottable("Gold", 1.0 if hard else 0.8, 30 if hard else 12)
		drops.add_item_to_loottable("HealthPotion", 0.35 if hard else 0.20, 2)
		drops.add_item_to_loottable("Sword", 0.10 if hard else 0.025, 1)
		drops.add_item_to_loottable("PlateBody", 0.035 if hard else 0.005, 1)
		drops.add_item_to_loottable("PlateHelm", 0.045 if hard else 0.008, 1)

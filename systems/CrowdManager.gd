extends Node2D
class_name CrowdManager

@export var crowd_count := 10
@onready var street: Area2D

const CROWD_MEMBER_SCN: PackedScene = preload("res://scenes/entities/crowd/CrowdMember.tscn")

func spawn_crowd() -> void:
	for i in range(crowd_count):
		spawn_npc()

func spawn_npc():
	var npc = CROWD_MEMBER_SCN.instantiate() as CrowdMember
	
	var spawn = street.get_spawn_point()
	npc.global_position = spawn
	
	npc.street = street
	npc.set_direction_from_spawn(spawn, street.get_center())

	add_child(npc)

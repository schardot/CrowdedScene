extends Node2D

@onready var player = $Entities/Player
@onready var stores_container = $Entities/Stores
@onready var car = $Entities/Car
@onready var crowd = $Entities/Crowd
@onready var street = $Environment/Street
@onready var entities_root = $Entities

func get_player():
	return player

func get_stores() -> Array:
	return stores_container.get_children()

func get_car():
	return car

func get_crowd():
	return crowd

func get_street():
	return street

func get_entities_root():
	return entities_root

extends Node2D

const CROSSING_NPC_SCN: PackedScene = preload("res://scenes/entities/crossing/CrossingNpc.tscn")

@onready var world: Node2D  = $World
@onready var player: Node = world.get_player()
@onready var crowd_container: CrowdManager = world.get_crowd()
@onready var street = world.get_street()
@onready var car: Node2D = world.get_car()

@export var crossing_spawn_chance: float = 0.2
@export var crossing_try_interval: float = 5.0
@export var crossing_row_memory_size: int = 2

var crossing_spawn_timer: Timer
var recent_crossing_rows: Array[int] = []

var stores: Array = []
var current_assignment_store: Area2D

func _ready() -> void:
	add_to_group("game")

	init_player()
	init_stores()
	init_lanes()
	_init_crossing_spawn_timer()

	generate_assignment()

func generate_assignment() -> void:
	if stores.is_empty():
		return

	var available_stores: Array = []
	for store in stores:
		if store != current_assignment_store:
			available_stores.append(store)

	if available_stores.is_empty():
		available_stores = stores.duplicate()

	current_assignment_store = available_stores.pick_random()
	player.set_goal(current_assignment_store.color)

func on_assignment_completed(_completed_store: Area2D) -> void:
	_completed_store.completed = false
	_completed_store.unblock_store()
	#crowd_container.call_deferred("spawn_npc")
	generate_assignment()

# ---- INIT FUNCTIONS

func init_player():
	if SceneManager.player_position != Vector2.ZERO:
		player.global_position = SceneManager.player_position

func init_stores():
	stores = get_tree().get_nodes_in_group("stores")
	for store in stores:
		store.unblock_store()
		store.player_entered.connect(func() -> void: on_assignment_completed(store))
	assert(stores.size() > 0)

func init_npcs(lane: LaneStruct):
	crowd_container.street = street
	if SceneManager.crowd_positions.size() > 0:
		for pos in SceneManager.crowd_positions:
			lane = LaneManager.get_nearest_lane_by_type(pos.x, LaneManager.LaneType.CROWD_MEMBER)
			crowd_container.spawn_npc(lane, pos)
		SceneManager.crowd_positions.clear()
	else:
		crowd_container.spawn_line(lane.line, lane)

func init_lanes():
	var i := 0
	for lane in LaneManager.LanesArray:	
		match lane.type:
			LaneManager.LaneType.CROWD_MEMBER:
					init_npcs(lane)
			LaneManager.LaneType.CAR:
					init_car(lane)
		i += 1

func init_car(lane: LaneStruct) -> void:
	if not car:
		return
	car.lane = lane
	car.spawn_car(street)

func _init_crossing_spawn_timer() -> void:
	crossing_spawn_timer = Timer.new()
	crossing_spawn_timer.one_shot = true
	crossing_spawn_timer.autostart = false
	crossing_spawn_timer.timeout.connect(_on_crossing_spawn_timer_timeout)
	add_child(crossing_spawn_timer)
	_schedule_next_crossing_try()

func _schedule_next_crossing_try() -> void:
	crossing_spawn_timer.wait_time = max(crossing_try_interval, 0.1)
	crossing_spawn_timer.start()

func _on_crossing_spawn_timer_timeout() -> void:
	try_spawn_crossing_npc()
	_schedule_next_crossing_try()

func try_spawn_crossing_npc() -> void:
	if randf() < crossing_spawn_chance:
		spawn_crossing_npc()

func spawn_crossing_npc() -> void:
	if not world:
		return

	var pair: Array = _pick_store_pair_with_memory()
	if pair.size() < 2:
		return

	var from_store: Node2D = pair[0]
	var to_store: Node2D = pair[1]
	if randf() < 0.5:
		var tmp: Node2D = from_store
		from_store = to_store
		to_store = tmp

	var npc: CrossingNpc = CROSSING_NPC_SCN.instantiate() as CrossingNpc
	world.get_entities_root().add_child(npc)
	npc.z_index = 3
	npc.spawn_from_stores(from_store, to_store)

func _pick_store_pair_with_memory() -> Array:
	var pairs: Array[Array] = world.get_store_pairs_by_row()
	if pairs.is_empty():
		return []

	var candidate_rows: Array[int] = []
	for i in range(pairs.size()):
		if not recent_crossing_rows.has(i):
			candidate_rows.append(i)

	if candidate_rows.is_empty():
		for i in range(pairs.size()):
			candidate_rows.append(i)

	var row_idx: int = candidate_rows.pick_random()
	_remember_crossing_row(row_idx, pairs.size())
	return pairs[row_idx]

func _remember_crossing_row(row_idx: int, total_rows: int) -> void:
	if crossing_row_memory_size <= 0:
		return
	var clamped_memory: int = clampi(crossing_row_memory_size, 1, max(total_rows - 1, 1))
	recent_crossing_rows.append(row_idx)
	while recent_crossing_rows.size() > clamped_memory:
		recent_crossing_rows.remove_at(0)

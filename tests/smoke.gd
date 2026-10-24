extends SceneTree

## Headless integration smoke test for the shared kits, loaded from their
## submodules under addons/. Proves each kit parses, its classes instantiate, and
## a few core behaviours hold. Run with:
##   godot --headless --path . --import
##   godot --headless --path . --script tests/smoke.gd
## Deep behavioural tests live in each genre template (e.g. the FPS weapons test).

var _failures := 0

func check(cond: bool, msg: String) -> void:
	if cond:
		print("PASS: " + msg)
	else:
		_failures += 1
		print("FAIL: " + msg)

func _initialize() -> void:
	_test_core()
	_test_settings_kit()
	_test_inventory_kit()
	_test_components_kit()
	print("RESULT: %d failures" % _failures)
	quit(1 if _failures > 0 else 0)

func _test_core() -> void:
	var event_bus = load("res://addons/core/event_bus.gd").new()
	check(event_bus.has_signal("entity_died"), "core: EventBus exposes entity_died")
	var scene_manager = load("res://addons/core/scene_manager.gd").new()
	scene_manager.register_level("main_menu", "res://x.tscn")
	check(scene_manager.resolve("main_menu") == "res://x.tscn", "core: SceneManager id -> path")
	check(scene_manager.resolve("res://y.tscn") == "res://y.tscn", "core: SceneManager passes raw paths through")
	for s in ["audio_manager", "save_manager", "localization", "debug_overlay"]:
		check(load("res://addons/core/%s.gd" % s) != null, "core: %s.gd loads" % s)

func _test_settings_kit() -> void:
	var sm = load("res://addons/settings_kit/settings_manager.gd").new()  # SettingsManager
	check(sm.has_method("save_keybinds") and sm.has_method("load_keybinds"), "settings_kit: rebind persistence API present")
	check(is_equal_approx(sm.get_brightness_adjustment(), 1.0), "settings_kit: brightness 50 -> 1.0x")
	var actions: Array[String] = ["jump"]
	sm.rebindable_actions = actions
	check(sm.rebindable_actions.size() == 1, "settings_kit: rebindable_actions is game-supplied")
	check(load("res://addons/settings_kit/rebind_container.tscn") != null, "settings_kit: RebindContainer scene loads")

func _test_inventory_kit() -> void:
	var item = load("res://addons/inventory_kit/item_resource.gd").new()  # ItemResource
	item.id = &"sword"
	item.type = &"melee-weapon"
	check(item.is_weapon() and item.is_melee(), "inventory_kit: ItemResource weapon predicates")
	var potion = load("res://addons/inventory_kit/item_resource.gd").new()
	potion.type = &"consumable"
	check(not potion.is_weapon(), "inventory_kit: consumable is not a weapon")
	var inv = load("res://addons/inventory_kit/inventory.gd").new()  # Inventory
	root.add_child(inv)  # runs _ready so the grid is set up
	check(inv.has_method("try_pickup"), "inventory_kit: Inventory.try_pickup present")
	check(load("res://addons/inventory_kit/inventory_slot.gd") != null, "inventory_kit: InventorySlot loads")
	inv.free()

func _test_components_kit() -> void:
	var health = load("res://addons/components_kit/health.gd").new()  # Health
	root.add_child(health)  # runs _ready
	health.take_damage(10.0)
	check(is_equal_approx(health.current_health, 90.0), "components_kit: Health takes 10 damage (100 -> 90)")
	health.heal(5.0)
	check(is_equal_approx(health.current_health, 95.0), "components_kit: Health heals (90 -> 95)")
	health.free()
	var sm = load("res://addons/components_kit/state_machine.gd")  # StateMachine
	check(sm != null, "components_kit: StateMachine loads")
	check(load("res://addons/components_kit/state.gd") != null, "components_kit: State base loads")

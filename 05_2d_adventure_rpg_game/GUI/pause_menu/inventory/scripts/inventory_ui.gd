extends Node
class_name InventoryUI

const INVENTORY_SLOT = preload("res://05_2d_adventure_rpg_game/GUI/pause_menu/inventory/inventory_slot.tscn")

var focus_index : int = 0

@export var data : InventoryData

func _ready() -> void:
	PauseMenu.shown.connect(update_inventory)
	PauseMenu.hidden.connect(clear_inventory)
	clear_inventory()
	data.changed.connect(on_inventory_changed)
	pass

func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()
	pass
	
func update_inventory() -> void:
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
		new_slot.focus_entered.connect(item_focused)
	await get_tree().process_frame
	get_child(focus_index).grab_focus()
	pass
	
func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = i
			return
	pass

func on_inventory_changed() -> void:
	clear_inventory()
	update_inventory()
	await get_tree().process_frame
	get_child(focus_index).grab_focus()
	pass

extends Resource
class_name InventoryData

@export var slots : Array[SlotData]

func _init() -> void:
	connect_slots()
	pass

func add_item(item : ItemData, count : int = 1) -> bool:
	for s in slots:
		if s and s.item_data == item:
			s.quantity += count
			return true
	
	for i in slots.size():
		if !slots[i]:
			var new = SlotData.new()
			new.item_data = item
			new.quantity = count
			slots[i] = new
			new.changed.connect(slot_changed)
			return true
			
	print("intentory was full ...")
	return false

func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect(slot_changed)

func slot_changed() -> void:
	for s in slots:
		#if s:
			#print("item:[" + s.item_data.name + "], quantity:" + str(s.quantity))
		if s and s.quantity < 1:
			s.changed.disconnect(slot_changed)
			var index = slots.find(s)
			slots[index] = null
			emit_changed()
	pass

## Gather the inventory into an array
func get_save_data() -> Array:
	var item_save : Array = []
	for i in slots.size():
		item_save.append(item_to_save(slots[i]))
	return item_save

## Convert each inventory item into a dictionay
func item_to_save(slot : SlotData) -> Dictionary:
	var result = {item = "", quantity = 0}
	if slot:
		result.quantity = slot.quantity
		if slot.item_data:
			result.item = slot.item_data.resource_path
	return result


func parse_save_data(save_data : Array) -> void:
	slots.clear()
	
	for i in save_data.size():
		slots.append(item_from_save(save_data[i]))
		
	connect_slots()
	pass

func item_from_save(save_object : Dictionary) -> SlotData:
	if save_object.item == "":
		return null
	var new_slot : SlotData = SlotData.new()
	new_slot.item_data = load(save_object.item)
	new_slot.quantity = int(save_object.quantity) 
	return new_slot
	
func use_item(item : ItemData, count : int = 1) -> bool:
	for s in slots:
		if s:
			if s.item_data == item and s.quantity >= count:
				s.quantity -= count
				return true
	return false

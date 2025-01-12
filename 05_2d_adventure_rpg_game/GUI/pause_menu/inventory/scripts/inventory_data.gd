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

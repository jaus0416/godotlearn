extends Node
class_name State

# 状态变更有很多种方式，这里推荐使用signal
signal transitioned

# 定义了状态的4种基本操作： enter exit update physics_update
func enter():
	pass

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

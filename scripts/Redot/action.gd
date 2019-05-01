extends Node

const ActionType = preload("res://scripts/Redot/action_type.gd")

################
# CLASS Action #
################
class_name Action, "res://assets/images/redot/action.svg"

var _type:ActionType
var _body:FuncRef
var _data:Dictionary = {} setget set_data, get_data

func _init(type:ActionType, data:Dictionary = {}, body:FuncRef = Utils.get_noop()) -> void:
  _type = type
  _body = body
  _data = data

#func run(state):
#  return _body.call_func(state.get_value(segment))

func get_type() -> String:
  return _type.type()

func set_data(data:Dictionary) -> Action:
  _data = data
  return self

func get_data() -> Dictionary:
  return _data
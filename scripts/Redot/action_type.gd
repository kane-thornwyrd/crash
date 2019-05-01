extends Node
####################
# CLASS ActionType #
####################
class_name ActionType, "res://assets/images/redot/action_type.svg"

var _type:String setget ,type
func _init(name:String):
  _type = name
func type():
  return _type.to_upper()
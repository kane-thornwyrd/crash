extends Node

################
# CLASS Action #
################

var _type:ActionType
var _seg:String
var _body:FuncRef

func _init(type:ActionType, segment:String, body:FuncRef):
  _type = type
  _seg = segment
  _body = body

func run(state):
  return _body.call_func(state.get_value(_seg))

func get_type() -> String:
  return _type.type()
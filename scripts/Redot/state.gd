extends Node

###############
# CLASS State #
###############
class_name State

const LAST_KEY = 0
var _state:Dictionary

func _init(initial_values:Dictionary):
  _state = initial_values.duplicate(true)

func _deep_set(path:PoolStringArray, obj:Dictionary, value):
  var _prev_key = path[LAST_KEY]
  path.remove(LAST_KEY)
  if not obj.has(_prev_key):
    obj[_prev_key] = {}
  if path.size() == LAST_KEY:
    obj[_prev_key] = value
    return obj
  else:
    return _deep_set(path, obj[_prev_key], value)

func _deep_get(path:PoolStringArray, obj:Dictionary, default):
  var _prev_key = path[LAST_KEY]
  path.remove(LAST_KEY)
  if not obj.has(_prev_key):
    return default
  if path.size() == LAST_KEY:
    return obj[_prev_key]
  else:
    return _deep_get(path, obj[_prev_key], default)

func set_value(path:String, value) -> void:
  var _address:PoolStringArray = path.split(".", true)
  var new_state = _state.duplicate(true)
  _deep_set(_address, new_state, value)
  _state = new_state

func get_value(path:String, default = null):
  var _address:PoolStringArray = path.split(".", true)
  var new_state = _state.duplicate(true)
  return _deep_get(_address, new_state, default)

func clone() -> State:
  return self._init(_state.duplicate(true))
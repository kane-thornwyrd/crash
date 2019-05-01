extends Node

class_name InputDevice, "res://assets/images/custom_nodes/keys.svg"

var input_device_action = Action.new(ActionType.new("input_device_action"))

var actions_activated:Dictionary

static func get_actions_dic() -> Dictionary:
  var out:Dictionary
  for action in InputMap.get_actions():
    out[action] = false
  return out

func _ready():
  actions_activated = get_actions_dic()
  set_process_input(true)

func _input(event) -> void:
  var modified = false
  get_tree().set_input_as_handled()
  for action in actions_activated:
    if event.is_action_pressed(action) and not actions_activated[action] :
      actions_activated[action] = true
      modified = true
    elif event.is_action_released(action) and actions_activated[action]:
      actions_activated[action] = false
      modified = true

  if modified:
    #warning-ignore:return_value_discarded
    GLOBAL.redot_instance.dispatch(input_device_action)

#warning-ignore:unused_argument
func state_input_reducer(state:State, data:Dictionary) -> State:
  return state.set_value("input_device", actions_activated)

func reduce(state:State, action:Action) -> State:
  match action.get_type():
    "INPUT_DEVICE_ACTION":
      return state_input_reducer(state, action.get_data())
  return state
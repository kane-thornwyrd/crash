tool
extends Node
######################
# CLASS DefaultState #
######################
class_name DefaultState, "res://assets/images/redot/default_state.svg"

const DEFAULT_STATE_GROUP = "redot_default_states"

export var values:Dictionary setget , get_default_state

func _enter_tree():
  if is_inside_tree() and not get_groups().has(DEFAULT_STATE_GROUP):
    add_to_group(DEFAULT_STATE_GROUP, true)

func get_default_state() -> Dictionary:
  return values
tool
extends Node

const Action = preload("res://scripts/Redot/action.gd")
const State = preload("res://scripts/Redot/state.gd")

#################
# CLASS Reducer #
#################
class_name Reducer, "res://assets/images/redot/reducer.svg"

const DEFAULT_REDUCER_GROUP = "redot_reducer"

export var reducer_node:NodePath

var reducer_containing_node:Node

func _enter_tree():
  reducer_node = get_parent().get_path()
  reducer_containing_node = get_node(reducer_node)
  if is_inside_tree() and not get_groups().has(DEFAULT_REDUCER_GROUP):
    add_to_group(DEFAULT_REDUCER_GROUP, true)

func reduce(state:State, action:Action) -> State:
  return reducer_containing_node.reduce(state, action)
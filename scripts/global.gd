extends Node

const UNIT_SIZE:int = 56

const Action = preload("res://scripts/Redot/action.gd")
const ActionType = preload("res://scripts/Redot/action_type.gd")
const State = preload("res://scripts/Redot/state.gd")
const DefaultState = preload("res://scripts/Redot/default_state.gd")
const Redot = preload("res://scripts/Redot/redot.gd")

var RNG:RandomNumberGenerator
var redot_instance:Redot
var tree_factory:Node
var screensize = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))

func _ready():
  RNG = RandomNumberGenerator.new()
  RNG.set_seed(654281684130531)

  var default_state:Dictionary = {}
  for node in get_tree().get_nodes_in_group(DefaultState.DEFAULT_STATE_GROUP):
    Utils.merge_dictionaries(default_state, node.get_default_state())

  redot_instance = Redot.new( funcref(self,"main_reducer"), State.new(default_state))

func main_reducer(state:State, action:Action):
  for node in get_tree().get_nodes_in_group(Reducer.DEFAULT_REDUCER_GROUP):
    Utils.merge_dictionaries(state._state, node.reduce(state, action)._state)
  return state

func load_resources():
  tree_factory = preload("res://data/factories/TreeFactory.tscn").instance()
extends Node

const UP:Vector2 = Vector2(0 , -1)
const DOWN:Vector2 = Vector2(0 , 1)
const LEFT:Vector2 = Vector2(-1 , 0)
const RIGHT:Vector2 = Vector2(1 , 0)

const UNIT_SIZE:int = 56

const Action = preload("res://scripts/Redot/action.gd")
const ActionType = preload("res://scripts/Redot/action_type.gd")
const State = preload("res://scripts/Redot/state.gd")
const Redot = preload("res://scripts/Redot/redot.gd")

var RNG:RandomNumberGenerator
var redot_instance:Redot
var tree_factory:Node
var screensize = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))

func _ready():
  RNG = RandomNumberGenerator.new()
  RNG.set_seed(654281684130531)

#  print(nsi.get_tree().call_group("redot", "get_default_state"))
  redot_instance = Redot.new( funcref(self,"main_reducer"), State.new({}))

func main_reducer(state, action):
  return state.clone()

func load_resources():
  tree_factory = preload("res://data/factories/TreeFactory.tscn").instance()
extends Node

const Action = preload("res://scripts/Redot/action.gd")
const DefaultState = preload("res://scripts/Redot/default_state.gd")
const State = preload("res://scripts/Redot/state.gd")

class_name Redot

signal state_updated(state)

var current_reducer:FuncRef
var current_state:State setget , get_state
var current_listeners:Array
var next_listeners:Array
var is_dispatching:bool

func _ready():
  current_reducer = null
  current_listeners = []
  next_listeners = current_listeners
  is_dispatching = false

func _init(reducer:FuncRef, preloaded_state:State):
  create_store(reducer, preloaded_state)

#/**
# * We won't allow enhancers, yet
# */
func create_store(reducer:FuncRef, preloaded_state:State):
  current_reducer = reducer
  current_state = preloaded_state
#warning-ignore:return_value_discarded
  dispatch(Action.new(ActionType.new("@@redot/INIT")))

func dispatch(action:Action) -> Action:
  if is_dispatching:
    pass

  if current_reducer != null:
    is_dispatching = true
    current_state = current_reducer.call_func(current_state, action)

  is_dispatching = false

  current_listeners = next_listeners
  var listeners = current_listeners
  for listener in listeners:
    var cb := listener as FuncRef
    cb.call_func()

  emit_signal("state_updated", current_state)

  return action


#/**
# * This makes a shallow copy of current_listeners so we can use
# * next_listeners as a temporary list while dispatching.
# *
# * This prevents any bugs around consumers calling
# * subscribe/unsubscribe in the middle of a dispatch.
# */
func ensure_can_mutate_next_listeners() -> void:
  if next_listeners == current_listeners:
    next_listeners = current_listeners.duplicate(true)

func get_state() -> State:
  return State.new(current_state._state) if !is_dispatching else null

#/**
# * We won't allow unsubscribing, yet
# */
func subscribe(listener:FuncRef):
  if is_dispatching:
    pass
  ensure_can_mutate_next_listeners()
  next_listeners.push_back(listener)



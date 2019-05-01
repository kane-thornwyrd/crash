extends KinematicBody2D

class_name Player

const SLOPE_STOP = 64
const DROP_THRU_BIT = 1


var stats = {
  "animation": "rest_left",
  "gravity" : 0,
  "is_grounded" : false,
  "is_jumping" : false,
  "jump_duration" : 0.5,
  "max_jump_height" : 2.5 * GLOBAL.UNIT_SIZE,
  "max_jump_velocity" : 0,
  "min_jump_height" : 0.8 * GLOBAL.UNIT_SIZE,
  "min_jump_velocity" : 0,
  "max_move_speed" : 5 * GLOBAL.UNIT_SIZE,
  "move_speed" : 5 * GLOBAL.UNIT_SIZE,
  "position": Vector2(),
  "velocity" : Vector2(),
}

var actions:Dictionary
var state_verbs:Array
var oldScale_collider
var transform_collider

var physics_processed_action = Action.new(ActionType.new("player_physics_processed"))

onready var collider = $physics_shape
onready var anim_player:AnimatedSprite = $godoty
onready var debug_text = $debug
onready var camera = $camera/shift_tween
var original_camera_pos

func _ready() -> void:
  original_camera_pos = camera.get_parent().position
  actions = InputDevice.get_actions_dic()
  stats.gravity = 2 * stats.max_jump_height / pow(stats.jump_duration, 2.0)
  stats.max_jump_velocity = -sqrt(2 * stats.gravity * stats.max_jump_height)
  stats.min_jump_velocity = -sqrt(2 * stats.gravity * stats.min_jump_height)
  transform_collider = collider.get_shape()
  oldScale_collider = transform_collider.get_extents()

func _physics_process(delta) -> void:
  var move_direction = -int(actions["move_left"]) + int(actions["move_right"])
  var boost = lerp( 1.0, int(actions["sprint"]) * (int(!actions["crouch"]) + 1.0), _get_h_weight()*2 )
  stats.move_speed = stats.max_move_speed * 0.2 if state_verbs.has("crouch") else stats.max_move_speed

  stats.velocity.x = lerp( stats.velocity.x, stats.move_speed * move_direction * boost, _get_h_weight() )

  stats.velocity.x = 0 if move_direction == 0 and abs(stats.velocity.x) < SLOPE_STOP else stats.velocity.x
  stats.velocity.y += stats.gravity * delta

  if stats.is_jumping and stats.velocity.y >= 0:
    stats.is_jumping = false

  var snap = Vector2.DOWN * 32 if !stats.is_jumping else Vector2.ZERO
  stats.velocity = move_and_slide_with_snap(stats.velocity, snap, Vector2.UP, true, 2, 0.99, false )
  var was_grounded = stats.is_grounded
  stats.is_grounded = !stats.is_jumping && is_on_floor()

  stats.position = position

  if actions.has("drop_down") and actions["drop_down"] and stats.is_grounded:
    set_collision_mask_bit(DROP_THRU_BIT, false)

  if actions["jump"] and stats.is_grounded:
    stats.velocity.y = stats.max_jump_velocity
    stats.is_jumping = true

  if not actions["jump"] and stats.velocity.y < stats.min_jump_velocity:
    stats.velocity.y = stats.min_jump_velocity

  _assign_animation(stats.animation)

  GLOBAL.redot_instance.dispatch(physics_processed_action.set_data({"data": stats}));

func physical_reaction_reducer(state:State, action:Dictionary) -> State:
  return state.set_value("player", action)

var side_suffix = "_right"
var pose = ""
var dashing = ""
func state_input_reducer(state:State, data:Dictionary) -> State:
  actions = state.get_value("input_device") as Dictionary

  if actions["move_left"]:
    side_suffix = "_left"
  elif actions["move_right"]:
    side_suffix = "_right"
  else:
    side_suffix = ""

  if actions["crouch"]:
    pose = "_crouch"

  if pose == "_crouch" and actions["move_up"]:
    pose = ""


  if actions["move_up"]:
    camera.interpolate_property(camera.get_parent(), "position:y", camera.get_parent().position.y, original_camera_pos.y-500, 0.5, camera.TRANS_LINEAR, camera.EASE_OUT)
    camera.start()

  if pose == "_crouch" or actions["sprint"] or side_suffix != "":
    camera.interpolate_property(camera.get_parent(), "position:y", camera.get_parent().position.y, original_camera_pos.y, 0.5, camera.TRANS_LINEAR, camera.EASE_OUT)
    camera.start()
    if actions["crouch"]:
      camera.interpolate_property(camera.get_parent(), "position:y", camera.get_parent().position.y, original_camera_pos.y+500, 0.5, camera.TRANS_LINEAR, camera.EASE_OUT)
      camera.start()


  if actions["sprint"]:
    dashing = "_dashing"
  else:
    dashing = ""
    actions["sprint"] = false

  var action = "rest"

  if actions["move_left"] or actions["move_right"]:
    action = "move"

  if actions["jump"]:
    pose = ""
    if is_on_floor() && actions["crouch"]:
      action = "drop_down"
      actions["drop_down"] = true
    else:
      action = "jump"

  var firing = ""
  if actions["fire"]:
    firing = "_fire"


  if pose.length() and pose == "_crouch":
    transform_collider.set_extents(Vector2 (oldScale_collider.x, oldScale_collider.y - 13))
  else:
    transform_collider.set_extents(Vector2 (oldScale_collider.x, oldScale_collider.y))

  stats.animation = str(action, side_suffix, pose, dashing, firing)

  state_verbs = [action, side_suffix.lstrip("_"), pose.lstrip("_"), dashing.lstrip("_"), firing.lstrip("_")]

  return state.set_value("input_device", actions)


func reduce(state:State, action:Action) -> State:
  match action.get_type():
    "PLAYER_PHYSICS_PROCESSED":
      return physical_reaction_reducer(state, action.get_data())
    "INPUT_DEVICE_ACTION":
      return state_input_reducer(state, action.get_data())
  return state


func _assign_animation(anim:String):
  debug_text.text = anim
  if anim_player.get_animation() != anim:
    anim_player.play(anim)

func _get_h_weight():
  return 0.2 if is_on_floor() else 0.1

#warning-ignore:unused_argument
func _on_Area2D_body_exited(body):
  set_collision_mask_bit(DROP_THRU_BIT, true)
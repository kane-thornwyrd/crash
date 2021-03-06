extends Control

const groundNode:PackedScene = preload("res://data/factories/worldgen/surface/ground.tscn")
const groundWithWaterNode:PackedScene = preload("res://data/factories/worldgen/surface/ground_with_water.tscn")

var origin_starting_height = 600.0
var terrain_size = 14
var half_terrain_size = terrain_size/2
var grounds:Array = []

var throttle_pool:Dictionary = {}

func _ready():
  GLOBAL.load_resources()

  var start_height
  var joint_height

  for i in range(terrain_size):
    if i == half_terrain_size: $player.position = Vector2((GLOBAL.screensize.x * i) + half_terrain_size , -10.0);
    start_height = origin_starting_height if i == 0 else joint_height
    joint_height = origin_starting_height if i == terrain_size - 1 else GLOBAL.RNG.randf_range(GLOBAL.screensize.y, 0)
    var heightMinusFifth = GLOBAL.screensize.y - GLOBAL.screensize.y/5
    var ground
    if start_height > heightMinusFifth or joint_height > heightMinusFifth:
      ground = groundWithWaterNode.instance()
    else:
      ground = groundNode.instance()
    ground.set_params(start_height, joint_height)
    ground.get_node("debug").text = str("TERRAIN: ", i)
    grounds.append(ground)
    ground.position = Vector2(GLOBAL.screensize.x * i, 0.0)
#warning-ignore:return_value_discarded
    ground.connect("exited", self, "_on_exiting_body_shape_exited", [i])
    add_child(ground)

#warning-ignore:unused_argument
func _on_exiting_body_shape_exited(body_id, body, body_shape, area_shape, index):
  var direction
  if area_shape == 0:
    direction = "left"
  else:
    direction = "right"

  if not throttle_pool.has(body_id):
    var new_throttle:Timer = Timer.new()
    new_throttle.set_one_shot(true)
    new_throttle.set_autostart(true)
    new_throttle.set_wait_time(1)
    throttle_pool[body_id] = {
      "id": index,
      "throttle": new_throttle,
      "body": body,
      "direction": direction
    }
#warning-ignore:return_value_discarded
    new_throttle.connect("timeout", self, "_on_throttle_timeout",[body_id, throttle_pool[body_id]])
    add_child(new_throttle)

func _on_throttle_timeout(body_id, throttle_informations):
  throttle_pool[body_id]["throttle"].queue_free()
#warning-ignore:return_value_discarded
  throttle_pool.erase(body_id)

  if body_id == $player.get_instance_id():
    player_move_ground(throttle_informations)

func player_move_ground(informations):
  if informations["direction"] == "left":
    grounds = Utils.array_shift(grounds, -1)
    grounds[0].position = Vector2(grounds[1].position.x - GLOBAL.screensize.x, 0.0)
  else:
    grounds = Utils.array_shift(grounds, 1)
    grounds[grounds.size()-1].position = Vector2(grounds[grounds.size()-2].position.x + GLOBAL.screensize.x, 0.0)


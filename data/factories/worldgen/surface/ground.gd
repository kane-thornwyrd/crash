extends Line2D

signal exited(body_id, body, body_shape, area_shape)

class_name GroundWithWater

export var displacement:float = 50.0
export var iterations = 7
export var start_height:float = 600.0
export var end_height:float = 600.0

var base_points:PoolVector2Array
export var smooth:float = 1.1
var current_displacement:float
var max_points = 2000

func set_params(start_height:float, end_height: float) -> GroundWithWater:
  base_points = PoolVector2Array([
    Vector2(0, start_height),
    Vector2(GLOBAL.screensize.x, end_height)
  ])
  init_line()
  return self

func init_line():
  current_displacement = displacement
  points = PoolVector2Array()
  add_point(base_points[0])
  add_point(base_points[base_points.size()-1])

  for i in range(iterations):
    add_points()

  return generate_infills(points)

func generate_infills(points:PoolVector2Array):
  var infill_points:PoolVector2Array = PoolVector2Array([Vector2(0, 2048)])
  infill_points.append_array(points)
  infill_points.append(Vector2(GLOBAL.screensize.x, 2048))
  $ground_infill.polygon = infill_points
  $collision/polygon.polygon = infill_points


func add_points():
  var old_points = points
  points = PoolVector2Array()
  for i in range(old_points.size() - 1):
    var midpoint = (old_points[i] + old_points[i+1]) / 2
    midpoint.y += current_displacement * pow(-1.0, GLOBAL.RNG.randi() % 2)
    add_point(old_points[i])
    add_point(midpoint)
  add_point(old_points[old_points.size()-1])
  current_displacement *= pow(2.0, -smooth)

func _on_exiting_body_shape_exited(body_id, body, body_shape, area_shape):
  emit_signal("exited", body_id, body, body_shape, area_shape)

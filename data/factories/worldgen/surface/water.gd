extends Polygon2D

var camera:Camera2D
var screen_size

func _ready():
  camera = get_node("/root/base/player/camera")
  screen_size = get_viewport_rect().size
  set_process(true)

func _process(delta):
  var camera_pos=camera.get_camera_position()
  camera_pos+=screen_size/2.0 #camera is centered, add half of screen
  var calc_pos=camera_pos-self.position
  var y_offset = calc_pos.y/screen_size.y
  y_offset=y_offset*2
  material.set_shader_param("y_offset", y_offset )
extends Node

func get_noop() -> FuncRef:
  return funcref(self, "noop")

static func noop() -> void:
  pass

static func print(obj):
  if obj is Object && obj.has_method("__print__"):
    print(obj.__print__())
  else:
    print(obj)

static func array_shift_by_ref(array:Array, shifting:int) -> void:
  var array_copy = array.duplicate(true)
  var arr_size = array.size()
  var true_shift = int(abs(shifting))%arr_size
  var right = sign(shifting) <= 0
  var i = 0
  if not right:
    for item in range(true_shift, arr_size):
      array[i] = array_copy[item]
      i += 1
    for item in range(0, true_shift):
      array[i] = array_copy[item]
      i += 1
  else:
    for item in range(arr_size - true_shift, arr_size):
      array[i] = array_copy[item]
      i += 1
    for item in range(0, arr_size - true_shift):
      array[i] = array_copy[item]
      i += 1


static func array_shift(array:Array, shifting:int) -> Array:
  var array_copy = array.duplicate(true)
  var arr_size = array_copy.size()
  var true_shift = int(abs(shifting))%arr_size
  var right = sign(shifting) <= 0
  var output:Array = []
  if not right:
    for item in range(true_shift, arr_size):
      output.append(array_copy[item])
    for item in range(0, true_shift):
      output.append(array_copy[item])
  else:
    for item in range(arr_size - true_shift, arr_size):
      output.append(array_copy[item])
    for item in range(0, arr_size - true_shift):
      output.append(array_copy[item])
  return output
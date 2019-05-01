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


class polygon2D_sorter:
  static func min_x(a, b):
    if a.x < b.x:
      return true
    return false
  static func min_y(a, b):
    if a.y < b.y:
      return true
    return false
  static func max_x(a, b):
    if a.x > b.x:
      return true
    return false
  static func max_y(a, b):
    if a.y > b.y:
      return true
    return false

static func merge_dictionaries(dic1:Dictionary, dic2:Dictionary):
  if dic1.size() == 0 and dic2.size() == 0: return dic1;

  for key in dic2.keys():
    if dic1.has(key):
      if dic1[key] is Dictionary and dic2[key] is Dictionary:
        merge_dictionaries(dic1[key], dic2[key])
      elif dic1[key] is Array and dic2[key] is Array:
        #warning-ignore:unused_variable
        for i in range(dic2[key].size() - 1):
          dic1[key].append(dic2[key].pop_front())
      else:
        dic1[key] = dic2[key]
    else:
      dic1[key] = dic2[key]

#  for key in dic2.keys():
#    if(dic1.has(key))

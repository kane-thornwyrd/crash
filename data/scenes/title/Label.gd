extends Label

func _ready() -> void:
  self.text = ProjectSettings.get_setting("application/config/name")

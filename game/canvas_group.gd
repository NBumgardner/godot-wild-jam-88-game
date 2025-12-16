@tool
extends CanvasGroup
func _process(_delta: float) -> void:
	material.set_shader_parameter("scale_factor", get_viewport_transform().get_scale())

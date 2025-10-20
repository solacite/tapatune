extends TextureButton

var taps = 0
var hover_angle = 15

func _ready() -> void:
	await get_tree().process_frame
	set_pivot_offset(size / 2)
	position -= size / 2

func _on_pressed() -> void:
	taps = taps + 1
	$"../Taps".text = str(taps)

func _on_mouse_entered() -> void:
	rotation_degrees = hover_angle

func _on_mouse_exited() -> void:
	rotation = 0

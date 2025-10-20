extends TextureButton

var taps = 0
var hover_angle = 0.8

func _ready() -> void:
	pass

func _on_vinyl_pressed() -> void:
	taps = taps + 1
	$"../Taps".text = str(taps)

func _on_vinyl_mouse_entered() -> void:
	print("HOVERING IS HAPPENING")
	rotation_degrees = hover_angle

func _on_vinyl_mouse_exited() -> void:
	rotation = 0

extends Node2D

var taps = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_vinyl_pressed() -> void:
	taps = taps + 1
	$Taps.text = str(taps)

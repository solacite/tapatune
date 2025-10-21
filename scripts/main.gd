extends Node

@onready var camera = $Camera2D
var capture
var THRESHOLD = 0.2
var zoom_normal = Vector2(1, 1)
var tween

func _ready():
	var bus_idx = AudioServer.get_bus_index("CaptureBus")
	capture = AudioServer.get_bus_effect(bus_idx, 0)
	
func _process(delta):
	if capture and capture.can_get_buffer(1024):
		var samples = capture.get_buffer(1024)
		var bass = get_bass_energy(samples)
		if bass > THRESHOLD:
			zoom_screen(bass)

func get_bass_energy(samples: PackedVector2Array) -> float:
	var total = 0.0
	var count = min(samples.size(), 128)
	for i in count:
		total += abs(samples[i].x)
	return total / count

func zoom_screen(bass):
	if tween:
		tween.kill()
	var bass_strength = clamp((bass - THRESHOLD) * 5, 0, 1)
	var min_zoom = 0.9
	var zoom_amount = lerp(1.0, min_zoom, bass_strength)
	var target_zoom = Vector2(zoom_amount, zoom_amount)
	tween = create_tween()
	tween.tween_property(camera, "zoom", target_zoom, 0.08).from(camera.zoom)
	tween.tween_property(camera, "zoom", zoom_normal, 0.15)

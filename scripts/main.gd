extends Node
# yoppee

# reference Camera2D node for zoom effect
@onready var camera = $Camera2D

# hold the AudioEffectCapture instance for analyzing audio
var capture

# threshold vars
var THRESHOLD = 0.14 # threshold for bass energy to trigger zoom
var HIGH_THRESHOLD = 0.14 # threshold for high-frequency energy to trigger flash

# general vars
var zoom_normal = Vector2(1, 1)
var tween

func _ready():
	# find custom audio bus get AudioEffectCapture for analysis
	var bus_idx = AudioServer.get_bus_index("CaptureBus")
	capture = AudioServer.get_bus_effect(bus_idx, 0)
	
func _process(delta):
	# continuously check for new audio data to analyze
	if capture and capture.can_get_buffer(1024):
		var samples = capture.get_buffer(1024)
		# analyze bass + trigger cam zoom if above threshold
		var bass = get_bass_energy(samples)
		if bass > THRESHOLD:
			zoom_screen(bass)
		# analyze high frequencies + trigger flash if above threshold
		var high = get_high_freq_energy(samples)
		if high > HIGH_THRESHOLD:
			flash_rect($VinylOutline)

# analyze lower frequencies (bass) by averaging the first 128 samples
func get_bass_energy(samples: PackedVector2Array) -> float:
	var count = min(samples.size(), 128)
	if count == 0:
		return 0.0 # prevent division by zero
	var total = 0.0
	for i in count:
		total += abs(samples[i].x)
	return total / count

# analyze higher frequencies by averaging the last 128 samples
func get_high_freq_energy(samples: PackedVector2Array) -> float:
	var count = min(samples.size(), 128)
	if count == 0:
		return 0.0 # prevent division by zero
	var total = 0.0
	# loop through last 'count' samples
	for i in range(samples.size() - count, samples.size()):
		total += abs(samples[i].x)
	return total / count

# zooms cam based on bass strength
func zoom_screen(bass):
	if tween:
		tween.kill() # kill running tweens
	# calc zoom strength based on how much bass exceeds threshold
	var bass_strength = clamp((bass - THRESHOLD) * 5, 0, 1)
	var min_zoom = 0.9 # min zoom factor (smaller = more zoomed in)
	var zoom_amount = lerp(1.0, min_zoom, bass_strength)
	var target_zoom = Vector2(zoom_amount, zoom_amount)
	tween = create_tween()
	# zoom + restore to default
	tween.tween_property(camera, "zoom", target_zoom * 1.2, 0.08).from(camera.zoom)
	tween.tween_property(camera, "zoom", zoom_normal, 0.15)

# flashes outline + fade out
func flash_rect(rect):
	rect.modulate.a = 1.0 # make fully visible
	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, 0.8) # fade out

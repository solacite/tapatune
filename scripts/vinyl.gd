extends TextureButton

var click_scale := Vector2(0.435, 0.435) # scale upon click
var hover_scale := Vector2(0.5, 0.5) # scale upon hover
var normal_scale := Vector2(0.445, 0.445) # default scale

var taps = 0 # Num of btn presses
var hover_angle = 15 # angle to rotate upon hover
var tween # tween object for anim

var target_rotation_degrees := 0.0           # Target rotation after each press
var rotation_step := 45.0                    # Degrees to rotate per click

@onready var audio_player := $"../Stereo"    # Reference to AudioStreamPlayer2D node
@onready var tap_label := $"../Taps"         # Reference to Taps label node

func _ready() -> void:
	# Set a visually pleasing default scale for tap label
	tap_label.scale = Vector2(2, 2)
	# Wait one frame for proper size calculation
	await get_tree().process_frame
	set_pivot_offset(size / 2)               # Set center as pivot for scaling/rotation
	position -= size / 2                     # Center vinyl on initial position
	scale = normal_scale                     # Set initial button scale

func animate_tap_counter():
	# Animate tap label to "pop" then return to default scale
	var rest_scale = Vector2(2, 2)
	var pop_scale = Vector2(2.5, 2.5)
	tap_label.scale = pop_scale
	var t = create_tween()
	t.tween_property(tap_label, "scale", rest_scale, 0.1)

func _on_pressed() -> void:
	animate_tap_counter()
	scale = click_scale                      # Shrink button on press
	taps += 1                                # Increment tap count
	tap_label.text = str(taps)               # Update tap label
	if tween:
		tween.kill()                         # Kill running tween if any
	tween = create_tween()
	tween.tween_property(self, "scale", normal_scale, 0.15) # Restore button scale

	# Increment target rotation and animate to it
	target_rotation_degrees += rotation_step
	animate_rotation_to_target()

	# play audio if not already playing
	if not audio_player.playing:
		audio_player.play(audio_player.get_playback_position())

# animate btn rotation to new target angle
func animate_rotation_to_target():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "rotation_degrees", target_rotation_degrees, 0.2)  # spin

# scale + rotate button upon hover
func _on_mouse_entered() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", hover_scale, 0.1)
	tween.tween_property(self, "rotation_degrees", target_rotation_degrees + hover_angle, 0.1)

# restore button scale + rotation when mouse leaves
func _on_mouse_exited() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", normal_scale, 0.1)
	tween.tween_property(self, "rotation_degrees", target_rotation_degrees, 0.1)

extends TextureButton

# scale values
var click_scale := Vector2(0.435, 0.435) # upon button click
var hover_scale := Vector2(0.5, 0.5) # upon mouse hover
var normal_scale := Vector2(0.445, 0.445) # default

var taps = 0 # num of btn presses
var hover_angle = 15 # degrees to rotate upon hover
var tween # tween obj --> smooth anims

var target_rotation_degrees := 0.0 # target rotation after each press
var rotation_step := 45.0 # degrees to rotate per click

@onready var audio_player := $"../Stereo" # reference AudioStreamPlayer2D node

func _ready() -> void:
	var label = $"../Taps"
	label.scale = Vector2(4.4, 4.4)
	# wait one frame to calculate size properly
	await get_tree().process_frame
	set_pivot_offset(size / 2) # set center as pivot for scaling/rotation
	position -= size / 2 # center vinyl on initial pos
	scale = normal_scale # set initial scale

func animate_tap_counter():
	var label = $"../Taps"
	label.scale = Vector2(6, 6)
	var t = create_tween()
	t.tween_property(label, "scale", Vector2.ONE, 0.1)

func _on_pressed() -> void:
	animate_tap_counter()
	scale = click_scale # shrink on press
	taps += 1 # inc tap count
	$"../Taps".text = str(taps) # update taps label
	if tween:
		tween.kill() # stop current tween (if any)
	tween = create_tween()
	tween.tween_property(self, "scale", normal_scale, 0.15) # restore default scale

	# inc target rotation + anim
	target_rotation_degrees += rotation_step
	animate_rotation_to_target()

	# start playing audio if not already playing
	if not audio_player.playing:
		audio_player.play(audio_player.get_playback_position())

func animate_rotation_to_target():
	# anim btn rotation to the new target angle with a tween
	if tween:
		tween.kill() # stop tween
	tween = create_tween()
	tween.tween_property(self, "rotation_degrees", target_rotation_degrees, 0.2) # spin

func _on_mouse_entered() -> void:
	# scale + tilt upon hover
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", hover_scale, 0.1)
	tween.tween_property(self, "rotation_degrees", target_rotation_degrees + hover_angle, 0.1)

func _on_mouse_exited() -> void:
	# restore to default scale and rotation when mouse leaves
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", normal_scale, 0.1)
	tween.tween_property(self, "rotation_degrees", target_rotation_degrees, 0.1)

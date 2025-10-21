extends TextureButton

var click_scale := Vector2(0.435, 0.435) # scale upon click
var hover_scale := Vector2(0.5, 0.5) # scale upon hover
var normal_scale := Vector2(0.445, 0.445) # default scale

var taps = 0 # Num of btn presses
var hover_angle = 15 # angle to rotate upon hover
var tween # tween object for anim

var target_rotation_degrees := 0.0 # target rotation after press
var rotation_step := 45.0 # degrees to rotate per click

@onready var audio_player := $"../Stereo" # ref AudioStreamPlayer2D
@onready var tap_label := $"../Taps" # ref label

# preload audio files into array
var audio_files = [
	preload("res://music/the boy is mine.mp3"),
	preload("res://music/[SPOTDOWNLOADER.COM] HOMESICK.mp3"),
	preload("res://music/[SPOTDOWNLOADER.COM] when the rain stops.mp3")
]

func _ready() -> void:
	tap_label.scale = Vector2(2, 2)
	await get_tree().process_frame
	set_pivot_offset(size / 2) # set center as pivot
	position -= size / 2 # center vinyl on initial pos
	scale = normal_scale # set initial btn scale
	randomize() # ensure randomness for audio selection

# anim label
func animate_tap_counter():
	var rest_scale = Vector2(2, 2)
	var pop_scale = Vector2(2.5, 2.5)
	tap_label.scale = pop_scale
	var t = create_tween()
	t.tween_property(tap_label, "scale", rest_scale, 0.1)

# Play a random audio file
func play_random_audio():
	var random_audio = audio_files[randi() % audio_files.size()]
	audio_player.stream = random_audio
	audio_player.play()

func _on_pressed() -> void:
	animate_tap_counter()
	scale = click_scale  # shrink btn on press
	taps += 1 # inc tap count
	tap_label.text = str(taps) # upd label
	if tween:
		tween.kill() # kill tween
	tween = create_tween()
	tween.tween_property(self, "scale", normal_scale, 0.15) # restore button scale

	# inc target rotation + anim
	target_rotation_degrees += rotation_step
	animate_rotation_to_target()

	# play audio if not already playing, choose random file if stopped
	if not audio_player.playing:
		play_random_audio()

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

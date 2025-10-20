extends TextureButton

var click_scale := Vector2(0.25, 0.25)
var hover_scale := Vector2(0.3, 0.3)
var normal_scale := Vector2(0.265, 0.265)

var taps = 0
var hover_angle = 15
var tween

@onready var audio_player := $"../AudioStreamPlayer2D"

func _ready() -> void:
	await get_tree().process_frame
	set_pivot_offset(size / 2)
	position -= size / 2
	scale = normal_scale

func _on_pressed() -> void:
	scale = click_scale
	taps += 1
	$"../Taps".text = str(taps)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", normal_scale, 0.15)
	
	if not audio_player.playing:
		audio_player.play(audio_player.get_playback_position())

func _on_mouse_entered() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", hover_scale, 0.1)
	tween.tween_property(self, "rotation_degrees", hover_angle, 0.1)

func _on_mouse_exited() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", normal_scale, 0.1)
	tween.tween_property(self, "rotation_degrees", 0, 0.1)

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

func flash_all():
	var flash_nodes = [
		$"../Flash/ColorRect",
		$"../Flash/ColorRect2",
		$"../Flash/ColorRect3",
		$"../Flash/ColorRect4",
		$"../Flash/ColorRect5",
		$"../Flash/ColorRect6"
	]
	for rect in flash_nodes:
		flash_rect(rect)

func flash_rect(rect):
	rect.modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, 0.3)

func _on_pressed() -> void:
	flash_all()
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

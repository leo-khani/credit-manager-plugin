@tool
extends MarginContainer

@onready var toast_label: Label = %ToastLabel

const FADE_DURATION: float = 0.3

func _ready() -> void:
	var credit_manager = get_tree().root.get_node_or_null("CreditManager")
	if credit_manager:
		if not credit_manager.is_connected("toast", _on_toast):
			credit_manager.connect("toast", _on_toast)
	
	modulate.a = 0.0

func _on_toast(message: String, duration: float, font_color: Color) -> void:
	toast_label.text = message
	toast_label.add_theme_color_override("font_color", font_color)
	
	await animate_in()
	await get_tree().create_timer(duration).timeout
	animate_out()

func animate_in() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, FADE_DURATION)
	await tween.finished

func animate_out() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, FADE_DURATION)
	await tween.finished
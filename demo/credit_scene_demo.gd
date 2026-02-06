extends Control

class_name CreditSceneDemo

@onready var rich_text_label: RichTextLabel = %RichTextLabel

# Configuration
@export var scroll_speed: float = 50.0 # Pixels per second
@export var title_font_size: int = 40
@export var category_font_size: int = 30
@export var item_font_size: int = 24
@export var star_wars_yellow: Color = Color(1, 0.9, 0.3)

var scroll_tween: Tween


func _ready() -> void:
	# Set up basic visuals
	rich_text_label.scroll_active = false
	rich_text_label.bbcode_enabled = true

	# 1. Build the text
	var full_text = build_credits_bbcode()
	rich_text_label.text = full_text

	# 2. Wait a frame for the label to resize based on content
	await get_tree().process_frame

	# 3. Start Scrolling
	start_scrolling()


func build_credits_bbcode() -> String:
	var text = "[center]"

	# --- Title ---
	text += "[font_size=%d][color=#%s]PROJECT TITLE[/color][/font_size]\n\n" % [title_font_size, star_wars_yellow.to_html()]
	text += "[i]A long time ago in a game engine far, far away...[/i]\n\n\n\n"

	# --- Credits By Category ---
	var categories = CreditEntryResource.CREDIT_CATEGORIES

	for category_enum in categories.keys():
		var category_name = categories[category_enum]
		var credits = CreditManager.get_credits_by_category(category_enum)

		if credits.is_empty():
			continue

		# Category Header
		text += "[font_size=%d][u]%s[/u][/font_size]\n\n" % [category_font_size, category_name.to_upper()]

		# Items
		for credit in credits:
			text += "[font_size=%d][b]%s[/b][/font_size]\n" % [item_font_size, credit.asset_name]
			text += "By [color=cadet_blue]%s[/color]\n" % credit.author
			if credit.description != "":
				text += "[i][font_size=%d]%s[/font_size][/i]\n" % [item_font_size - 4, credit.description]
			text += "\n"

		text += "\n\n"

	text += "[/center]"
	return text


func start_scrolling() -> void:
	# Reset scroll
	rich_text_label.position.y = size.y
	#to suit the text length which is longer than screen size
	rich_text_label.size.y = rich_text_label.get_content_height()
	# Calculate how far to scroll
	var content_height = rich_text_label.get_content_height()
	var target_y = -content_height - 100 # Scroll slightly past screen

	var distance = abs(target_y - rich_text_label.position.y)
	var duration = distance / scroll_speed

	if scroll_tween:
		scroll_tween.kill()

	scroll_tween = create_tween()
	scroll_tween.tween_property(rich_text_label, "position:y", target_y, duration)

	# Check for when it finishes
	scroll_tween.finished.connect(_on_scroll_finished)


func _on_scroll_finished() -> void:
	# Optional: Loop or change scene
	print("Credits finished!")
	# get_tree().change_scene_to_file("res://MainMenu.tscn")


func _process(_delta: float) -> void:
	# Simple input to speed up
	if Input.is_action_pressed("ui_accept"): # Space / Enter
		scroll_tween.set_speed_scale(5.0)
	else:
		scroll_tween.set_speed_scale(1.0)

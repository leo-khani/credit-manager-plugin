@tool
extends Control

@onready var asset_name_label: Label = %AssetNameLabel
@onready var category_label: Label = %CategoryLabel
@onready var license_label: Label = %LicenseLabel
@onready var author_label: Label = %AuthorLabel
@onready var link_label: Label = %LinkLabel
@onready var description_label: Label = %DescriptionLabel

@onready var asset_name_line_edit: LineEdit = %AssetNameLineEdit
@onready var category_options: OptionButton = %CategoryOptions
@onready var license_options: OptionButton = %LicenseOptions
@onready var author_line_edit: LineEdit = %AuthorLineEdit
@onready var link_line_edit: LineEdit = %LinkLineEdit
@onready var description_text_edit: TextEdit = %DescriptionTextEdit

@onready var link_preview_btn: Button = %LinkPreviewBtn
@onready var revert_btn: Button = %RevertBtn
@onready var add_btn: Button = %AddBtn

@export var credit_entry: CreditEntryResource = CreditEntryResource.new():
	set(value):
		credit_entry = value
		if is_node_ready():
			clear_fields()

var new_credit_entry: CreditEntryResource
var current_link: String = ""
var url_regex: RegEx = RegEx.new()

signal credit_added


func _init() -> void:
	# Regex pattern for validating standard URL structures
	url_regex.compile("^(https?://)[\\w.-]+(?:\\.[\\w.-]+)+[/\\w._~:/?#\\[\\]@!$&'()*+,;=]*$")


func _ready() -> void:
	_connect_signals()
	link_preview_btn.disabled = true
	clear_fields()


## Establishes all internal signal connections
func _connect_signals() -> void:
	# Standard Button Actions
	if not add_btn.pressed.is_connected(_on_add_btn_pressed):
		add_btn.pressed.connect(_on_add_btn_pressed)
	if not revert_btn.pressed.is_connected(_on_revert_btn_pressed):
		revert_btn.pressed.connect(_on_revert_btn_pressed)

	# Link Logic
	if not link_preview_btn.pressed.is_connected(_on_link_preview_btn_pressed):
		link_preview_btn.pressed.connect(_on_link_preview_btn_pressed)
	if not link_line_edit.text_changed.is_connected(_on_link_text_changed):
		link_line_edit.text_changed.connect(_on_link_text_changed)

# --- Logic Methods ---


## Resets the UI fields based on the currently assigned credit_entry resource
func clear_fields() -> void:
	new_credit_entry = CreditEntryResource.new()

	# Field Text Reset
	asset_name_line_edit.text = credit_entry.asset_name
	author_line_edit.text = credit_entry.author
	link_line_edit.text = credit_entry.link
	description_text_edit.text = credit_entry.description

	# Dropdown: Categories
	category_options.clear()
	for category_id in CreditEntryResource.CREDIT_CATEGORIES.keys():
		category_options.add_item(CreditEntryResource.CREDIT_CATEGORIES[category_id], category_id)
	category_options.selected = category_options.get_item_index(credit_entry.category)

	# Dropdown: Licenses
	license_options.clear()
	for license_id in CreditEntryResource.LICENSE_TYPES.keys():
		license_options.add_item(CreditEntryResource.LICENSE_TYPES[license_id], license_id)
	license_options.selected = license_options.get_item_index(credit_entry.license)

	# Refresh validation states
	_on_link_text_changed(link_line_edit.text)


## Validates the link format and toggles the preview button
func update_link_preview_button() -> void:
	var stripped_link = link_line_edit.text.strip_edges()
	var is_valid = url_regex.search(stripped_link) != null
	link_preview_btn.disabled = not is_valid


## Saves the captured UI data into a new Resource file
func save_credit_resource() -> bool:
	if not CreditManager:
		return false
	# 1. Ensure the directory exists first so we can scan it
	if not DirAccess.dir_exists_absolute(CreditManager.DEFAULT_CREDIT_PATH):
		DirAccess.make_dir_absolute(CreditManager.DEFAULT_CREDIT_PATH)

	# 2. Open the directory and count existing .tres files
	var dir = DirAccess.open(CreditManager.DEFAULT_CREDIT_PATH)
	var file_count: int = 0

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# Only count files that are not directories and end with .tres
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				file_count += 1
			file_name = dir.get_next()

	# 3. Format the name: "Number Name"
	var safe_name = new_credit_entry.asset_name.validate_filename()
	if safe_name == "":
		safe_name = "asset_credit"

	# We use (file_count + 1) so the first file starts at 1
	var numbered_name = "%d-%s" % [file_count + 1, safe_name]
	var final_path = CreditManager.DEFAULT_CREDIT_PATH + numbered_name + ".tres"

	# 4. Save the resource
	var result = ResourceSaver.save(new_credit_entry, final_path)

	if result == OK:
		EditorInterface.get_resource_filesystem().scan()
		CreditManager.add_toast("Credit added successfully", 2.0, Color(1, 1, 1, 1))
		CreditManager.credits_updated.emit()
		return true

	else:
		push_error("Failed to save credit resource. Error: %d" % result)
		CreditManager.add_toast("Failed to save credit resource", 2.0, Color(1, 0, 0, 1))
		return false


func _on_add_btn_pressed() -> void:
	if asset_name_line_edit.text == "":
		CreditManager.add_toast("Asset name cannot be empty", 2.0, Color(1, 0, 0, 1))
		return

	new_credit_entry.asset_name = asset_name_line_edit.text
	new_credit_entry.author = author_line_edit.text
	new_credit_entry.link = link_line_edit.text
	new_credit_entry.description = description_text_edit.text

	add_btn.disabled = true
	add_btn.text = "Saving..."

	# Cast IDs to appropriate Enums
	new_credit_entry.category = category_options.get_selected_id() as CreditEntryResource.CreditCategory
	new_credit_entry.license = license_options.get_selected_id() as CreditEntryResource.LicenseType

	await save_credit_resource()
	add_btn.disabled = false
	add_btn.text = "Add Credit"


func _on_revert_btn_pressed() -> void:
	clear_fields()


func _on_link_preview_btn_pressed() -> void:
	var url = link_line_edit.text.strip_edges()
	if url != "":
		OS.shell_open(url)


func _on_link_text_changed(new_text: String) -> void:
	current_link = new_text
	update_link_preview_button()

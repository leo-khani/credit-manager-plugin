@tool
extends EditorPlugin

const AUTOLOAD_NAME = "CreditManager"
const AUTOLOAD_PATH = "res://addons/credit_manager/credit_manager.gd"
const DOCK_PATH = "uid://byuhivbsphyqw"
var dock

func _enter_tree():
	# Load your dock scene
	await get_tree().create_timer(0.1).timeout
	dock = preload("uid://byuhivbsphyqw").instantiate()
	
	# Force the dock to expand to fill available space
	dock.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dock.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	# Add it to the bottom panel
	add_control_to_bottom_panel(dock, "Credits")

func _exit_tree():
	# 2. Clean up UI
	remove_control_from_bottom_panel(dock)
	if dock:
		dock.queue_free()

func _enable_plugin():
	# 3. Add the Autoload so the game can read credits at runtime
	# This points to a script that will handle loading/saving the data
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)

func _disable_plugin():
	# 4. Remove the Autoload when plugin is turned off
	remove_autoload_singleton(AUTOLOAD_NAME)
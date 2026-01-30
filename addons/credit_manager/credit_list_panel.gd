@tool
extends Panel

# 1. Load the script manually since Autoload is gone
const CREDIT_CARD_SCENE = preload("uid://jr525rfgqsk8")

@onready var refresh_btn: Button = %RefreshBtn
@onready var credit_list_vbox: VBoxContainer = %CreditListVBox
@onready var credit_count_label: Label = %CreditCountLabel


func _ready() -> void:
	update_list()

	if refresh_btn:
		refresh_btn.pressed.connect(update_list)

	if CreditManager:
		CreditManager.credits_updated.connect(update_list)


func update_list() -> void:
	if not credit_list_vbox:
		return

	for child in credit_list_vbox.get_children():
		child.queue_free()

	# 2. Call the static function from the loaded script
	var credit_resources = CreditManager.get_all_credits()
	credit_count_label.text = "Credits: %d" % credit_resources.size()
	for res in credit_resources:
		var card = CREDIT_CARD_SCENE.instantiate()
		credit_list_vbox.add_child(card)

		# Use your component's method (update_list or setup)
		if card is CreditComponent:
			card.update_list(res)

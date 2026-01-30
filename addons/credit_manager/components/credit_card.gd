@tool
extends Control
class_name CreditComponent

@onready var asset_name_label: Label = %AssetNameLabel
@onready var category_label: Label = %CategoryLabel
@onready var license_label: Label = %LicenseLabel
@onready var author_label: Label = %AuthorLabel
@onready var link_btn: LinkButton = %LinkBtn
@onready var description_label: Label = %DescriptionLabel
@onready var asset_name_foled_title: FoldableContainer = %AssetNameFoledTitle
## Populates the UI component with data from a CreditEntryResource
func update_list(data: CreditEntryResource) -> void:
	if not is_node_ready():
		await ready

	asset_name_foled_title.folded = true

	# Basic Text fields
	if asset_name_label:
		asset_name_label.text = data.asset_name
	
	if asset_name_foled_title:
		asset_name_foled_title.title = data.asset_name
	
	if author_label:
		author_label.text = data.author
	
	if description_label:
		description_label.text = data.description
	
	# LinkButton handles its own URI opening usually, but we set the text/uri here
	if link_btn:
		link_btn.text = data.link
		link_btn.uri = data.link
	
	# Mapping Enums to Strings using the Dictionaries in your Resource
	if category_label:
		if data.category in CreditEntryResource.CREDIT_CATEGORIES:
			category_label.text = CreditEntryResource.CREDIT_CATEGORIES[data.category]
		else:
			category_label.text = "Unknown Category"
		
	if license_label:
		if data.license in CreditEntryResource.LICENSE_TYPES:
			license_label.text = CreditEntryResource.LICENSE_TYPES[data.license]
		else:
			license_label.text = "Unknown License"
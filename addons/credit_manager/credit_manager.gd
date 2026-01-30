@tool
extends Node

const DEFAULT_CREDIT_PATH = "credits/"

signal toast(message: String, duration: float, font_color: Color)
signal credits_updated


func add_toast(message: String, duration: float, font_color: Color) -> void:
	toast.emit(message, duration, font_color)
	print(message)


## Helper functions
func get_all_credits() -> Array[CreditEntryResource]:
	var credits: Array[CreditEntryResource] = []
	for file in DirAccess.get_files_at(DEFAULT_CREDIT_PATH):
		if file.ends_with(".tres"):
			var credit = load(DEFAULT_CREDIT_PATH + file)
			if credit:
				credits.append(credit)
	return credits


func get_credits_by_category(category: CreditEntryResource.CreditCategory) -> Array[CreditEntryResource]:
	var credits: Array[CreditEntryResource] = []
	for file in DirAccess.get_files_at(DEFAULT_CREDIT_PATH):
		if file.ends_with(".tres"):
			var credit = load(DEFAULT_CREDIT_PATH + file)
			if credit and credit.category == category:
				credits.append(credit)
	return credits

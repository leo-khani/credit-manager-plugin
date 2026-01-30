extends Node

const CREDIT_PATH = "res://credits/"

## Scans the directory and returns an Array of CreditEntryResource objects
static func get_credits_res() -> Array[CreditEntryResource]:
	var results: Array[CreditEntryResource] = []
	
	# Ensure the directory exists
	if not DirAccess.dir_exists_absolute(CREDIT_PATH):
		DirAccess.make_dir_absolute(CREDIT_PATH)
		return results

	var dir = DirAccess.open(CREDIT_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Only process .tres files (ignore .import files)
			if file_name.ends_with(".tres"):
				var full_path = CREDIT_PATH + file_name
				var res = load(full_path)
				if res is CreditEntryResource:
					results.append(res)
			
			file_name = dir.get_next()
		dir.list_dir_end()
	
	return results

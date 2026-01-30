extends Resource

class_name CreditEntryResource

enum CreditCategory {
	GENERAL,
	PROGRAMMING,
	ART,
	DESIGN,
	MUSIC,
	SOUND,
	TESTING,
	OTHER,
}

const CREDIT_CATEGORIES: Dictionary = {
	CreditCategory.GENERAL: "General",
	CreditCategory.PROGRAMMING: "Programming",
	CreditCategory.ART: "Art",
	CreditCategory.DESIGN: "Design",
	CreditCategory.MUSIC: "Music",
	CreditCategory.SOUND: "Sound",
	CreditCategory.TESTING: "Testing",
	CreditCategory.OTHER: "Other",
}

enum LicenseType {
	UNKNOWN,
	MIT,
	GPL,
	APACHE,
	BSD,
	PROPRIETARY,
	CC0,
	CC_BY,
	CC_BY_SA,
	CC_BY_NC,
}

const LICENSE_TYPES: Dictionary = {
	LicenseType.UNKNOWN: "Unknown",
	LicenseType.MIT: "MIT License",
	LicenseType.GPL: "GNU General Public License",
	LicenseType.APACHE: "Apache License",
	LicenseType.BSD: "BSD License",
	LicenseType.PROPRIETARY: "Proprietary License",
	LicenseType.CC0: "Creative Commons Zero (CC0)",
	LicenseType.CC_BY: "CC BY (Attribution)",
	LicenseType.CC_BY_SA: "CC BY-SA (ShareAlike)",
	LicenseType.CC_BY_NC: "CC BY-NC (Non-Commercial)",
}

@export var license: LicenseType = LicenseType.UNKNOWN

@export var asset_name: String = ""
@export var category: CreditCategory = CreditCategory.GENERAL
@export var author: String = ""
@export var link: String = ""
@export var description: String = ""

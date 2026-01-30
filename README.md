# Godot Credit Manager

**A professional, easy-to-use plugin for managing and displaying game credits in Godot 4.**

Manage your attributions, licenses, and contributor credits directly from the Godot Editor, and access them easily via code to create stunning credit sequences.

![Godot 4](https://img.shields.io/badge/Godot_4.x-Compatible-478cbf?style=flat&logo=godot-engine)
![License](https://img.shields.io/badge/License-MIT-green)

---

## ✨ Features

- **Integrated Dock**: Add, edit, and delete credits without leaving the editor.
- **Resource-Based**: Saves every credit entry as a native `.tres` file for easy version control.
- **Categorization**: Organize credits by *Programming*, *Art*, *Music*, *Sound*, *Design*, and more.
- **License Tracking**: Built-in dropdowns for common licenses (MIT, CC0, CC-BY, etc.).
- **Global Access**: `CreditManager` singleton provides instant access to your data from anywhere in your code.
- **Demo Scene**: Includes a "Star Wars" style scrolling credits example.

## 📦 Installation

1. Download the latest release or clone this repository.
2. Copy the `addons/credit_manager` folder into your project's `addons/` directory.
3. Open **Project > Project Settings > Plugins**.
4. Enable **Credit Manager**.

## 🚀 Usage

### 1. Adding Credits
1. Open the **Credits** bottom panel/dock in the editor.
2. Fill in the **Asset Name**, **Author**, **Category**, and other details.
3. Click **Add Credit**. 
   * Provides immediate feedback and creates a resource file in `res://credits/`.

### 2. Accessing Credits in Code
The plugin creates a singleton named `CreditManager`. use it to fetch your data:

```gdscript
# Get all credits in the "Music" category
var music_credits = CreditManager.get_credits_by_category(CreditEntryResource.CreditCategory.MUSIC)

for entry in music_credits:
    print("Song: %s by %s" % [entry.asset_name, entry.author])
```

### 3. Creating a Credits Screen
Check `res://demo/credit_scene_demo.tscn` for a full example.

**Basic Implementation:**
```gdscript
func _ready():
    var all_credits = CreditManager.get_all_credits()
    for credit in all_credits:
        # Instantiate your UI row/label here
        pass
```


## 🛠️ Testing & Dummy Data
Need to test your UI layout? You can generate placeholder data instantly:
```gdscript
# Generate 5 random entries for testing
CreditManager.generate_dummy_credits(5)
```

## 📄 License
This plugin is available under the MIT License. See `LICENSE` for more details.

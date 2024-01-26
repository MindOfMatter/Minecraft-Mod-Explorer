# Minecraft-Mod-Explorer

## Description
Minecraft-Mod-Explorer is a PowerShell tool (`search_mods.ps1`) designed to enhance the Minecraft gaming experience. It assists players in efficiently locating and organizing information about their installed Minecraft mods. The script generates an interactive HTML table, detailing each mod's name, description, categories, file size, and providing direct links to CurseForge or Modrinth pages.

## Requirements
- PowerShell 5.0 or higher.
- [ATLauncher](https://atlauncher.com/downloads)
- Access to mod files and `instance.json` in your Minecraft instance directory.

## Setup Instructions
1. **Locate Your Minecraft Instance Directory**: 
   Commonly found in `C:\Games\Microsoft\Minecraft\Launchers\ATLauncher\instances\YourInstanceName`.

2. **Place the Script in the Instance Directory**: 
   Copy `search_mods.ps1` into your Minecraft instance directory.

3. **Ensure Required Files Are Present**: 
   Verify the presence of `mods` folder and `instance.json` file in the same directory as the script.

## Usage
1. **Run the Script**:
   - Open PowerShell.
   - Navigate to the directory containing `search_mods.ps1`.
   - Execute the script with `.\search_mods.ps1`.

2. **View Mod Information**:
   - After script execution, locate `ModLinks.html` in the same directory.
   - Open `ModLinks.html` in a web browser to view the mod list with sorting options.

## Features
- **Comprehensive Mod Details**: Lists mod names, descriptions, categories, and file sizes.
- **File Size Visualization**: Comparative size display of each mod file.
- **Direct External Links**: Quick access to CurseForge or Modrinth mod pages.
- **Advanced Sorting**: Sort mods by various attributes for easier navigation.
- **Visual Appeal**: Integrates mod images for enhanced browsing.

## Example
<img width="960" alt="chrome_ywKn82cBEZ" src="https://github.com/MindOfMatter/Minecraft-Mod-Explorer/assets/35126123/3715fe32-bd71-41cf-86ce-b5260667136e">

## Notes
- The script is non-intrusive and only reads Minecraft mod files.
- Verify PowerShell script execution permissions on your system.

## Contributing
Contributions to CV-Generator are welcome! Please read `CONTRIBUTING.md` for details on our code of conduct and the process for submitting pull requests.

## License
This project is licensed under the GPL-3.0 license - see the `LICENSE` file for details.

## Acknowledgments
- Thanks to all possible contributors who have helped to build this tool.

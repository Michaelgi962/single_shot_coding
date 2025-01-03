Here’s the complete README in a single markdown block, ready to copy and paste:

markdown
Copy code
# single_shot_code

This repository contains Bash scripts designed to initialize projects with a single command. Each script automates:

- Creating project directories.
- Setting up Python virtual environments.
- Installing required dependencies.
- Generating starter files.

## How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/your_username/single_shot_code.git
   cd single_shot_code
   ```

## Run a setup script:
- The project will be initialized in the current working directory.
   ```bash
   ./setup_<project_name>.sh
   ```

## Activate the virtual environment:

   ```bash
   source <project_folder>/venv/bin/activate
   ```

## run the main project file

   ```bash
   Python <main_project_file>
   ```

# Example: Click Flick
The setup_click_flick.sh script initializes a project called Click Flick, a tool for controlling the mouse cursor with hotkeys.

Features:
Move the cursor to the center of monitors using Ctrl+Alt+<number>.
Move the cursor to specific regions using Ctrl+Alt+W/E/R/S/D/F/X/C/V.
Run the script, activate the virtual environment, and execute the Python file to start using Click Flick.

Contributing
Contributions are welcome! Add new setup scripts, ensure they follow the existing structure, and submit a pull request.

License
This repository is licensed under the MIT License.

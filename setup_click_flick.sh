#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define project variables
PROJECT_NAME="click_flick"
VENV_NAME="venv"

# Step 1: Create the project directory
echo "Setting up project: $PROJECT_NAME"
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Step 2: Create and activate Python virtual environment
echo "Creating virtual environment: $VENV_NAME"
python3 -m venv $VENV_NAME
source $VENV_NAME/bin/activate

# Step 3: Install required Python packages
echo "Installing required Python packages..."
pip install --upgrade pip
pip install pynput screeninfo pyautogui

# Step 4: Create the main Python script
echo "Creating Python script..."
cat <<EOF > click_flick.py
import pyautogui
from screeninfo import get_monitors
from pynput import keyboard

# Get the centers of all monitors and sort them from left to right
def get_monitor_centers():
    monitors = get_monitors()
    sorted_monitors = sorted(monitors, key=lambda m: m.x)  # Sort monitors by x position (left to right)
    centers = {}
    for i, monitor in enumerate(sorted_monitors, start=1):
        centers[i] = (
            monitor.x + monitor.width // 2,
            monitor.y + monitor.height // 2
        )
    return centers

# Display assigned monitor numbers
def display_monitor_assignments(monitor_centers):
    print("Monitors automatically assigned as follows (from left to right):")
    for number, (x, y) in monitor_centers.items():
        print(f"Monitor {number}: Center at ({x}, {y})")

# Move cursor within the active monitor to the center of the specified region
def move_to_region(x, y, width, height, row, column):
    region_x = x + (column - 1) * (width // 3) + (width // 6)
    region_y = y + (row - 1) * (height // 3) + (height // 6)
    pyautogui.moveTo(region_x, region_y)

# Ensure cursor visibility with a small movement
def ensure_cursor_visibility():
    pyautogui.moveRel(0, 1)  # Briefly move down
    pyautogui.moveRel(0, -1)  # Move back up

# Global variables to track keys pressed
active_modifiers = set()
monitor_centers = {}
poll_interval = 0.2  # Polling interval to reduce CPU usage (in seconds)

# Key mappings for regions (row, column)
region_hotkeys = {
    "w": (1, 1), "e": (1, 2), "r": (1, 3),
    "s": (2, 1), "d": (2, 2), "f": (2, 3),
    "x": (3, 1), "c": (3, 2), "v": (3, 3),
    "u": (1, 1), "i": (1, 2), "o": (1, 3),
    "j": (2, 1), "k": (2, 2), "l": (2, 3),
    "m": (3, 1), ",": (3, 2), ".": (3, 3),
}

# Handle key press events
def on_press(key):
    try:
        # Track modifier keys
        if key in (keyboard.Key.ctrl, keyboard.Key.alt):
            active_modifiers.add(key)
        elif hasattr(key, "char") and key.char.isdigit():
            # Check if required modifiers are active
            if keyboard.Key.ctrl in active_modifiers and keyboard.Key.alt in active_modifiers:
                key_number = int(key.char)
                if key_number in monitor_centers:
                    x, y = monitor_centers[key_number]
                    pyautogui.moveTo(x, y)
                    ensure_cursor_visibility()
                    print(f"Cursor moved to monitor {key_number} at ({x}, {y})")
        elif hasattr(key, "char") and key.char.lower() in region_hotkeys:
            if keyboard.Key.ctrl in active_modifiers and keyboard.Key.alt in active_modifiers:
                current_x, current_y = pyautogui.position()
                for monitor in get_monitors():
                    if monitor.x <= current_x < monitor.x + monitor.width and monitor.y <= current_y < monitor.y + monitor.height:
                        row, column = region_hotkeys[key.char.lower()]
                        move_to_region(monitor.x, monitor.y, monitor.width, monitor.height, row, column)
                        ensure_cursor_visibility()
                        print(f"Cursor moved to region ({row}, {column}) of the current monitor.")
    except AttributeError:
        pass

# Handle key release events
def on_release(key):
    try:
        if key in active_modifiers:
            active_modifiers.remove(key)
    except KeyError:
        pass

if __name__ == "__main__":
    import time
    print("Welcome to Click Flick!")
    monitor_centers = get_monitor_centers()
    display_monitor_assignments(monitor_centers)

    print("Listening for hotkeys (Control+Alt+<number>, Control+Alt+<W/E/R/S/D/F/X/C/V/U/I/O/J/K/L/M/,.>)...")
    with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
        while True:
            time.sleep(poll_interval)  # Reduce CPU usage by sleeping between event checks
EOF

# Step 5: Create a README file
echo "Creating README.md..."
cat <<EOF > README.md
# Click Flick

Click Flick is a tool that moves your mouse pointer to the center of a monitor or to specific regions within the active monitor using customizable hotkeys.

## Installation and Setup

1. Run the setup script:
   \`\`\`
   ./setup_click_flick.sh
   \`\`\`

2. Activate the virtual environment:
   \`\`\`
   source venv/bin/activate
   \`\`\`

3. Run the Click Flick Python script:
   \`\`\`
   python click_flick.py
   \`\`\`

4. Monitors are automatically assigned numbers from left to right based on their horizontal positions.

5. Use hotkeys:
   - **Control+Alt+<number>**: Flick cursor to the center of the corresponding monitor.
   - **Control+Alt+<W/E/R/S/D/F/X/C/V/U/I/O/J/K/L/M/,.>**: Move cursor to a specific region within the current monitor:
     - **W/E/R**: Top row (left, middle, right)
     - **S/D/F**: Middle row (left, middle, right)
     - **X/C/V**: Bottom row (left, middle, right)
     - **U/I/O/J/K/L/M/,/.**: Same as above with alternative keys.
EOF

# Step 6: Print success message
echo "Project $PROJECT_NAME setup is complete!"
echo "Navigate to the $PROJECT_NAME directory, activate the virtual environment, and run the script to start using Click Flick."

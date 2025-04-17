#!/bin/bash

# --- Configuration ---
# Directory to store user-specific .desktop files
DESKTOP_DIR="$HOME/.local/share/applications"
# Suffix to add to the base name for the .desktop file name
LAUNCHER_SUFFIX="-kitty"
# Suffix for the display name
DISPLAY_SUFFIX_PROG=" (Kitty)"
DISPLAY_SUFFIX_SESS=" (Kitty Session)"

# --- Script Logic ---

# Function to display usage instructions
usage() {
	echo "Usage: $0 <target> [IconName]"
	echo "  <target>      : The command name of the terminal program (e.g., htop, ranger)"
	echo "                : OR the path to a Kitty session file (e.g., ~/.config/kitty/my-session.conf)."
	echo "  [IconName]    : (Optional) The name of the icon to use (e.g., utilities-terminal, vim)."
	echo "                  If omitted, the script derives a default from <target>."
	echo
	echo "Examples:"
	echo "  ./create_kitty_launcher.sh htop"
	echo "  ./create_kitty_launcher.sh /path/to/my-project.conf"
	echo "  ./create_kitty_launcher.sh nvim vim"
	echo "  ./create_kitty_launcher.sh ~/.config/kitty/dev-session.conf kitty"
	exit 1
}

# Check if at least one argument (target) is provided
if [ -z "$1" ]; then
	echo "Error: No program or session file specified."
	usage
fi

TARGET="$1"
ICON_NAME_ARG="$2" # Store optional icon name argument

# Check if kitty is installed and executable
if ! command -v kitty &>/dev/null; then
	echo "Error: 'kitty' command not found or not executable."
	echo "Please ensure Kitty terminal is installed and in your system's PATH."
	exit 1
fi

# --- Determine Target Type and Prepare Variables ---
LAUNCH_MODE="" # 'executable' or 'session'
EXEC_COMMAND=""
DISPLAY_NAME=""
DEFAULT_ICON_NAME=""
DESKTOP_FILENAME_BASE=""
COMMENT=""

# 1. Check if TARGET is an executable file (directly or via PATH)
if command -v "$TARGET" &>/dev/null || ([ -f "$TARGET" ] && [ -x "$TARGET" ]); then
	LAUNCH_MODE="executable"
	# Prefer command found in PATH if available, otherwise use the provided path
	if command -v "$TARGET" &>/dev/null; then
		PROGRAM_NAME=$(basename "$TARGET") # Use basename if found in PATH
		EXEC_TARGET="$PROGRAM_NAME"        # Execute using name found in PATH
	else
		PROGRAM_NAME=$(basename "$TARGET")     # Use basename from the file path
		EXEC_TARGET="$(readlink -f "$TARGET")" # Execute using absolute path
	fi

	EXEC_COMMAND="kitty -e $EXEC_TARGET"
	DISPLAY_NAME="${PROGRAM_NAME^}${DISPLAY_SUFFIX_PROG}" # Capitalize first letter
	DEFAULT_ICON_NAME="$PROGRAM_NAME"
	DESKTOP_FILENAME_BASE="$PROGRAM_NAME"
	COMMENT="Run $PROGRAM_NAME in the Kitty terminal"

# 2. Check if TARGET is a readable file (potential session file)
elif [ -f "$TARGET" ] && [ -r "$TARGET" ]; then
	LAUNCH_MODE="session"
	SESSION_FILE_PATH="$(readlink -f "$TARGET")" # Get absolute path
	SESSION_FILENAME=$(basename "$TARGET")
	SESSION_NAME_NO_EXT="${SESSION_FILENAME%.*}" # Remove extension for names

	# Check if it looks like a session file (ends with .conf) - provides a warning if not
	if [[ "$SESSION_FILENAME" != *.conf ]]; then
		echo "Warning: '$TARGET' is a file but does not end with .conf. Assuming it's a Kitty session file anyway."
	fi

	EXEC_COMMAND="kitty --session \"$SESSION_FILE_PATH\""        # Quote path for safety
	DISPLAY_NAME="${SESSION_NAME_NO_EXT^}${DISPLAY_SUFFIX_SESS}" # Capitalize base name
	DEFAULT_ICON_NAME="$SESSION_NAME_NO_EXT"                     # Default icon from session name without ext
	DESKTOP_FILENAME_BASE="$SESSION_NAME_NO_EXT"
	COMMENT="Launch Kitty session: $SESSION_FILENAME"

# 3. Target not found or not identifiable
else
	echo "Error: '$TARGET' is not found as an executable program (in PATH or directly)"
	echo "       nor as a readable file (potential session file)."
	usage
fi

# Determine final Icon Name (use argument if provided, otherwise default)
ICON_NAME="${ICON_NAME_ARG:-$DEFAULT_ICON_NAME}"

# Ensure the target directory exists
mkdir -p "$DESKTOP_DIR"
if [ ! -d "$DESKTOP_DIR" ]; then
	echo "Error: Could not create directory '$DESKTOP_DIR'."
	exit 1
fi

# Define the full path for the new .desktop file
DESKTOP_FILE_PATH="$DESKTOP_DIR/${DESKTOP_FILENAME_BASE}${LAUNCHER_SUFFIX}.desktop"

echo "--- Creating Desktop Launcher ---"
echo "Target:        $TARGET"
echo "Type:          $LAUNCH_MODE"
echo "Exec Command:  $EXEC_COMMAND"
echo "Display Name:  $DISPLAY_NAME"
echo "Icon:          $ICON_NAME"
echo "Launcher File: $DESKTOP_FILE_PATH"
echo "-------------------------------"

# Create the .desktop file content using a heredoc
cat <<EOF >"$DESKTOP_FILE_PATH"
[Desktop Entry]
Version=1.1
Name=$DISPLAY_NAME
GenericName=Terminal Application/Session
Comment=$COMMENT
Exec=$EXEC_COMMAND
Icon=$ICON_NAME
Type=Application
Terminal=false
Categories=Utility;System;ConsoleOnly;TerminalEmulator;
Keywords=$DESKTOP_FILENAME_BASE;terminal;console;kitty;session;
EOF

# Check if the file was created successfully
if [ $? -ne 0 ]; then
	echo "Error: Failed to write to '$DESKTOP_FILE_PATH'."
	exit 1
fi

# Update the desktop database to make the new launcher visible
echo "Updating desktop application database..."
update-desktop-database -q "$DESKTOP_DIR"

echo "Success! Created '$DESKTOP_FILE_PATH'."
echo "The '$DISPLAY_NAME' launcher should now be available in your application menu."

exit 0

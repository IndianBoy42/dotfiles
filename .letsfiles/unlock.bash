#!/bin/bash

# Script to decrypt (gpg) and extract (tar.gz) an archive
# created by pack_encrypt.sh.
# Usage: ./pack_decrypt.sh <encrypted_archive.gpg>

# --- Argument Check ---
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <encrypted_archive.gpg>"
	echo "Error: Please provide exactly one argument: the path to the encrypted archive."
	echo "Example: $0 my_backup.gpg"
	exit 1
fi

# --- Variables ---
ENCRYPTED_ARCHIVE="$1"

# --- Check required commands ---
if ! command -v gpg >/dev/null 2>&1; then
	echo "Error: 'gpg' command not found. Please install GnuPG (package often called gnupg or gnupg2)."
	exit 1
fi
if ! command -v tar >/dev/null 2>&1; then
	echo "Error: 'tar' command not found. Please install tar."
	exit 1
fi

# --- Input File Validation ---
# Check if the input file exists and is a regular file
if [ ! -f "$ENCRYPTED_ARCHIVE" ]; then
	echo "Error: Input file '$ENCRYPTED_ARCHIVE' not found or is not a regular file."
	exit 1
fi

# --- Decrypt and Extract ---
echo "--------------------------------------------------"
echo "Attempting to decrypt and extract:"
echo "  Archive: $ENCRYPTED_ARCHIVE"
echo "  Target Directory: Current directory ($(pwd))"
echo "--------------------------------------------------"
echo "Starting decryption and extraction..."
echo "You will be prompted by GPG to enter the passphrase."
echo "Executing: gpg -d \"$ENCRYPTED_ARCHIVE\" | tar xzf -"

# Pipe gpg output to tar:
# gpg: -d = decrypt. Reads from file, outputs to stdout by default.
# tar: x = extract, z = filter through gzip, f - = read archive from standard input
#      Use 'v' (xzf -> xzvf) if you want to see the list of files being extracted.
gpg -d "$ENCRYPTED_ARCHIVE" | tar xzf -
# To see files listed during extraction, use:
# gpg -d "$ENCRYPTED_ARCHIVE" | tar xzvf -

# --- Check for Errors ---
# Capture exit statuses immediately after the pipe
# PIPESTATUS is a bash-specific array holding exit statuses of commands in the last pipe.
# Index 0 is gpg, Index 1 is tar.
gpg_status=${PIPESTATUS[0]}
tar_status=${PIPESTATUS[1]}

# Optional Debugging: Uncomment the next line to see the exact statuses captured
# echo "[Debug] gpg_status='${gpg_status}', tar_status='${tar_status}'"

# Check GPG status first
# Use -ne 0 to check for *any* GPG error
if [ "$gpg_status" -ne 0 ]; then
	echo "--------------------------------------------------"
	# Now try to provide more specific feedback if possible
	# Check if $gpg_status looks like an integer before using -eq
	if [[ "$gpg_status" =~ ^[0-9]+$ ]] && [ "$gpg_status" -eq 2 ]; then
		# Specific GPG error code 2: Often bad passphrase or decryption failure
		echo "Error: Decryption (gpg) failed. This often means an incorrect passphrase or a corrupted file (GPG Status: $gpg_status)."
	elif [ "$gpg_status" -eq 127 ]; then
		# Specific error code 127: Command not found (though checked earlier, belt-and-suspenders)
		echo "Error: Decryption (gpg) command failed. Status 127 usually means the 'gpg' command was not found or could not execute."
	else
		# General GPG error, report the status code
		echo "Error: Decryption (gpg) command failed with status $gpg_status."
	fi
	# No cleanup needed typically, as no intermediate files were created.
	exit 1 # Exit immediately on GPG failure
fi

# If GPG succeeded (status 0), then check Tar status
if [ "$tar_status" -ne 0 ]; then
	echo "--------------------------------------------------"
	echo "Error: Extraction (tar) failed with status $tar_status."
	echo "This might indicate the archive data stream from gpg was corrupted,"
	echo "or there were issues writing files (e.g., permissions, disk space)."
	# Files might be partially extracted. Manual cleanup might be needed by the user.
	exit 1
fi

# --- Success ---
echo "--------------------------------------------------"
echo "Successfully decrypted and extracted archive:"
echo "  $ENCRYPTED_ARCHIVE"
echo "Contents extracted to the current directory."
echo "--------------------------------------------------"

exit 0

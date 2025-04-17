#!/bin/bash

# Script to create a compressed (tar.gz) and encrypted (gpg) archive
# from a list of input paths.
# Usage: ./pack_encrypt.sh <output_archive.gpg> <path1> [path2] ...

# --- Basic Argument Count Check ---
if [ "$#" -lt 2 ]; then
	echo "Usage: $0 <output_archive.gpg> <path1> [path2] ..."
	echo "Error: Please provide the output archive name and at least one path."
	echo "Example: $0 my_backup.gpg /home/user/documents /etc/myapp.conf"
	exit 1
fi

# --- !!! NEW SAFETY CHECK !!! ---
# Check if the *first* argument (intended output file) *already exists*.
# If it does, it's highly likely the user forgot the output filename and
# provided a source path as the first argument instead.
if [ -e "$1" ]; then
	# Check if it's a directory, as overwriting a directory like this is very destructive.
	if [ -d "$1" ]; then
		echo "Error: The first argument '$1' is an existing directory."
	else
		echo "Error: The first argument '$1' is an existing file."
	fi
	echo "This script expects the *first* argument to be the *name* of the new archive file to create."
	echo "It appears you may have forgotten to specify the output archive filename."
	echo ""
	echo "Correct Usage: $0 <output_archive.gpg> <path1> [path2] ..."
	# Suggest what the user might have intended, using all provided args as sources
	echo "If you intended to archive all provided paths, maybe you meant:"
	echo "  $0 my_archive_name.gpg \"$@\""
	echo ""
	echo "Aborting to prevent accidental data loss."
	exit 1
fi
# --- End of New Safety Check ---

# --- Variables ---
# Now it's safer to assign $1 as the output file
ENCRYPTED_ARCHIVE="$1"
shift # Remove the output filename from the argument list ($@)

# Now $@ contains only the paths to be archived

# --- Check if output file already exists (Redundant with the check above, but kept for clarity/future?) ---
# Note: The check above prevents using an *existing* source path as the output.
# This check handles the case where the user *correctly* specified an output file name,
# but that file *already exists* from a previous run. We can arguably remove this
# check now, but keeping it offers a slightly different confirmation message.
# Let's keep it for the explicit "Overwrite?" confirmation.
if [ -e "$ENCRYPTED_ARCHIVE" ]; then
	# Use -i flag for read to handle backslashes in input, -p for prompt
	read -i "" -p "Output file '$ENCRYPTED_ARCHIVE' already exists. Overwrite? (y/N): " confirm
	# Check if the confirmation is 'y' or 'Y', otherwise exit
	if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
		echo "Aborted."
		exit 1
	fi
	echo "Overwriting existing file."
fi

# --- Input Path Validation ---
echo "Checking input paths..."
all_paths_valid=true
for path in "$@"; do
	# Check if path exists (-e) or is a symbolic link (-L) that might be broken
	# Use -e which works for files, directories, and valid symlinks
	if [ ! -e "$path" ]; then
		echo "Warning: Input path '$path' does not exist or is not accessible."
		all_paths_valid=false
		# Decide whether to exit or continue. Let's continue but warn.
		# To abort immediately if any path is invalid, uncomment the next line:
		# exit 1
	fi
done

if [ "$all_paths_valid" = false ]; then
	read -i "" -p "One or more input paths were not found. Continue anyway? (y/N): " continue_confirm
	if [[ ! "$continue_confirm" =~ ^[Yy]$ ]]; then
		echo "Aborted."
		exit 1
	fi
	echo "Continuing despite missing paths..."
fi

# --- Create Compressed and Encrypted Archive ---
echo "--------------------------------------------------"
echo "Archiving and encrypting paths:"
# Print each path on a new line for clarity if there are many
printf "  %s\n" "$@"
echo "Output file: ${ENCRYPTED_ARCHIVE}"
echo "--------------------------------------------------"
echo "Starting compression and encryption..."
echo "You will be prompted by GPG to enter and verify a passphrase."

# Pipe tar output to gpg:
# tar: c=create, z=gzip compress, f - = output to standard output
#      Piping paths using null delimiter (--null -T -) is safer for weird filenames,
#      but requires preparing the input list differently. Sticking to "$@" for simplicity here.
#      Handle paths with spaces correctly due to quoting "$@".
# gpg: --symmetric (or -c) = use symmetric cipher (password)
#      --cipher-algo AES256 = specify encryption algorithm (strong default)
#      -o "$ENCRYPTED_ARCHIVE" = write output to the specified file
#      Reads from standard input (the pipe from tar)
#      --batch --yes: Suppress some informational messages and assume "yes" to questions
#                     (like overwriting, though we handle that separately).
#      --passphrase-fd 0: Read passphrase from file descriptor 0 (stdin).
#                         Requires prompting separately or piping it in.
#                         GPG usually handles the interactive prompt well by default.
#                         Let's stick to the simpler interactive prompt unless issues arise.

# Simpler command relying on gpg's interactive prompt:
tar czf - "$@" | gpg --symmetric --cipher-algo AES256 -o "${ENCRYPTED_ARCHIVE}"

# --- Check for Errors ---
# PIPESTATUS is a bash-specific array holding exit statuses of commands in the last pipe.
# Index 0 is tar, Index 1 is gpg.
tar_status=${PIPESTATUS[0]}
gpg_status=${PIPESTATUS[1]}

if [ "$tar_status" -ne 0 ]; then
	echo "--------------------------------------------------"
	echo "Error: Archiving (tar) failed with status $tar_status."
	# Attempt to clean up potentially incomplete encrypted file if gpg started
	if [ -e "$ENCRYPTED_ARCHIVE" ]; then
		echo "Cleaning up potentially incomplete file: $ENCRYPTED_ARCHIVE"
		rm -f "$ENCRYPTED_ARCHIVE"
	fi
	exit 1
fi

if [ "$gpg_status" -ne 0 ]; then
	echo "--------------------------------------------------"
	echo "Error: Encryption (gpg) failed with status $gpg_status."
	# gpg might have created a zero-byte or incomplete file, remove it
	if [ -e "$ENCRYPTED_ARCHIVE" ]; then
		echo "Cleaning up potentially incomplete file: $ENCRYPTED_ARCHIVE"
		rm -f "$ENCRYPTED_ARCHIVE"
	fi
	exit 1
fi

# --- Success ---
echo "--------------------------------------------------"
echo "Successfully created compressed and encrypted archive: ${ENCRYPTED_ARCHIVE}"
echo ""
echo "To decrypt and extract:"
echo "  gpg -d \"${ENCRYPTED_ARCHIVE}\" | tar xz"
echo "Or, to decrypt to a file first:"
echo "  gpg -o archive.tar.gz -d \"${ENCRYPTED_ARCHIVE}\""
echo "  tar xzf archive.tar.gz"
echo "--------------------------------------------------"

exit 0

clear
echo "Loading System Files..."
sleep 5
echo "
░▒▓████████▓▒░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░ ░▒▓███████▓▒░ 
░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        
░▒▓█▓▒░     ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        
░▒▓██████▓▒░░▒▓█▓▒░      ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░  
░▒▓█▓▒░     ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░ 
░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░ 
░▒▓████████▓▒░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓███████▓▒░  
                                                                 
Installer Beta for Linux

"

# Start time tracking
START_TIME=$SECONDS
DURATION=2 # Run for 2 seconds

# The loop runs as long as the elapsed time is less than the desired duration
while [ $((SECONDS - START_TIME)) -lt $DURATION ]; do
    for s in / - \\ \|; do
        # Check time again before printing and sleeping to ensure a clean exit
        if [ $((SECONDS - START_TIME)) -ge $DURATION ]; then
            break 2 # Break both inner and outer loops
        fi
        
        # Print the spinner
        printf "\rPlease Wait... Setup is checking system...%s" "$s"
        
        # Pause for a short time
        sleep .1
    done
done

# Clean up the line after the loop finishes
printf "\r\033[K"
echo "Setup Files Loaded!"

sleep 0.3

whoami

#!/bin/bash

# Function to ask the question and process the answer
ask_yes_no() {
    local prompt="$1"
    local answer

    # Loop until a valid answer is provided
    while true; do
        # Prompt the user
        read -r -p "$prompt (y/n): " answer
        
        # Convert input to lowercase for consistent checking
        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

        case "$answer" in
            y|yes)
                echo ""
                return 0 # Return 0 for 'success' (Yes)
                ;;
            n|no)
                echo ""
                return 1 # Return 1 for 'failure' (No)
                ;;
            *)
                echo "Invalid input. Please enter 'y' for Yes or 'n' for No."
                ;;
        esac
    done
}

# --- Main Script Execution ---

# 1. Call the function with your question
ask_yes_no "Is this "ROOT"?"

# 2. Check the exit code ($?) to determine the answer
if [ $? -eq 0 ]; then
    echo "Loading..."
    # Your 'Yes' code block goes here
else
    echo "WARNING! BY CONTINUING, YOU UNDERSTAND THE RISKS OF BRICKING YOUR LINUX SOFTWARE! IF YOURE OK WITH POTENTIALLY REINSTALLING LINUX, YOU MAY CONTINUE. THINGS MAY BE SLOWER!"
    # Your 'No' code block goes here
fi

echo "If you selected no, please enter password for superuser accsess. don't mind the error."

sudo echo "continuing with setup..."
sleep 0.3
clear
echo "
░▒▓████████▓▒░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░ ░▒▓███████▓▒░
░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
░▒▓█▓▒░     ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░
░▒▓██████▓▒░░▒▓█▓▒░      ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░
░▒▓█▓▒░     ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░
░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░
░▒▓████████▓▒░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓███████▓▒░

Select Install Disk Location (MUST HAVE LINUX INSTALLED ON!!)
As of now, this installer cannot install linux with the EchOS Software.

"

#!/bin/bash

# ==========================================================
# --- INITIAL ARCHITECTURE CHECK & ROOT CHECK ---
# ==========================================================
# Check system architecture
ARCH=$(uname -m)
if [[ "$ARCH" == *"arm"* ]] || [[ "$ARCH" == *"aarch64"* ]]; then
    echo "=================================================="
    echo "ERROR: This software only supports x64-based computers. Exiting installer."
    echo "=================================================="
    exit 1
fi

# Check for root permissions (required for creating /echos and writing to /etc)
if [ "$EUID" -ne 0 ]; then
    echo "=================================================="
    echo "ERROR: This script must be run with sudo or as root to write to / and /etc."
    echo "=================================================="
    exit 1
fi

# ==========================================================
# --- ARGUMENT PARSING & GLOBAL FLAGS ---
# ==========================================================

# Command-line argument parser flag (Default: enabled)
AUTOSTART_ENABLED="true"

# Process command-line arguments
for arg in "$@"; do
    case $arg in
        --noauto)
            # Flag detected: autostart configuration will be skipped.
            AUTOSTART_ENABLED="false"
            ;;
        *)
            # Ignore other unknown arguments for now
            ;;
    esac
done

# ==========================================================
# --- 1. CORE CONFIGURATION & PATHS ---
# ==========================================================

# Installation Paths and Source Config
INSTALL_DATA_DIR="/EchOS_Installer_Data"
FINAL_INSTALL_DIR="/echos" # The fixed directory where the software will live

# --- DOWNLOAD/EXTRACTION CONFIG ---
ARCHIVE_FILENAME="echos-base.zip" # Using a placeholder name for the downloaded archive
# UPDATED: Using the direct MediaFire download URL provided by the user. 
# This is much more reliable than the file page URL.
SOFTWARE_DOWNLOAD_URL="https://download1648.mediafire.com/lsuj7m70owtgltQioizu2LcX24uju49nyhU-9hjfVy1aFmvjA74SO8PceFKm5fxPqdEOf-7io9X59KDGhmeHUGdIw1p0258Rc1KHNv0OXWjnbx1iEQ16t9I-UbEJDkrr85rC7AG4jPURnE5KyLREs8XMcuS-t74hDbeR7sILEXZV/8ru25n07cn45g41/EchOS+0.2+Preview+%28Echo+OS%29%283%29.zip"
EXTRACTED_DIR_NAME="EchOS_0.2_Preview_(Echo_OS)(3)" # Assumed folder name after extraction

# Full paths for archive and extracted source
INSTALL_ARCHIVE_PATH="${INSTALL_DATA_DIR}/${ARCHIVE_FILENAME}"
INSTALL_SOURCE_PATH="${INSTALL_DATA_DIR}/${EXTRACTED_DIR_NAME}" # The directory containing the extracted root system


# Minimum Hardware Requirements (Still checked, but no disk check)
MIN_RAM_GB=1
MIN_CORES=2

# Dependency Package Names (Required by handle_software_download_and_extract)
# Format: [Command Name]="apt_package_name dnf_package_name"
declare -A DEPENDENCIES=(
    ["wget"]="wget wget"                # Needed to download the file
    ["7z"]="p7zip-full p7zip"          # 7z/p7zip is used for extraction
)

# ==========================================================
# --- 2. AUTOSTART CONFIGURATION CONTENT ---
# ==========================================================

# --- A. Desktop Session Autostart (/root/.xinitrc) ---
AUTOSTART_PICOM_COMMAND="picom &"
AUTOSTART_SESSION_COMMAND="exec /usr/bin/echos-session" 

# The full content of the .xinitrc file
XINITRC_CONTENT="#!/bin/bash

# This script is executed by 'startx' or a display manager for a desktop session.

# 1. Start Picom (Compositor) in the background (&)
echo \"Starting Picom compositor...\"
${AUTOSTART_PICOM_COMMAND}

# 2. Start the main EchOS desktop session.
echo \"Starting EchOS Desktop in fullscreen...\"
${AUTOSTART_SESSION_COMMAND}
"

# --- B. System Boot Autostart (/etc/echos-boot-start.sh) ---
BOOT_START_SCRIPT_CONTENT="#!/bin/bash
#
# This script is the main system autostart entry point for the EchOS application.
# It is designed to be executed early in the boot process (e.g., via systemd service or init.d).

# 1. Change directory to the application root
cd ${FINAL_INSTALL_DIR} || { echo \"Error: ${FINAL_INSTALL_DIR} directory not found! Aborting EchOS application start.\"; exit 1; }

# 2. Execute the user-defined start script (the main application entry point)
echo \"Executing ./start.sh from ${FINAL_INSTALL_DIR}...\"
sudo su
cd /echos
exec ./start.sh
"


# ----------------------------------------------------------------------
# --- STEP 1: HARDWARE CHECK ---
# ----------------------------------------------------------------------

# Function to check if the current machine meets CPU and RAM requirements
check_hardware_requirements() {
    echo "=========================================="
    echo "  System Hardware Check"
    echo "=========================================="
    local error=0

    # 1. RAM Check (Minimum 1 GB)
    local total_ram_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
    local total_ram_gb=$((total_ram_kb / 1024 / 1024))
    
    echo "Checking RAM (Required: ${MIN_RAM_GB} GB)..."
    if [ "$total_ram_gb" -ge "$MIN_RAM_GB" ]; then
        echo "  PASS: Found $total_ram_gb GB RAM."
    else
        echo "  FAIL: Only found $total_ram_gb GB RAM. Required minimum is ${MIN_RAM_GB} GB."
        error=1
    fi

    # 2. CPU Core Check (Minimum 2 cores)
    local cpu_cores=$(nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo)
    
    echo "Checking CPU Cores (Required: ${MIN_CORES})..."
    if [ "$cpu_cores" -ge "$MIN_CORES" ]; then
        echo "  PASS: Found $cpu_cores CPU cores."
    else
        echo "  FAIL: Only found $cpu_cores CPU cores. Required minimum is ${MIN_CORES} cores."
        error=1
    fi
    
    if [ $error -eq 1 ]; then
        echo "------------------------------------------"
        echo "Hardware requirements NOT met. Installation cannot proceed."
        return 1
    else
        echo "------------------------------------------"
        echo "Hardware requirements met. Continuing setup."
        return 0
    fi
}


# ----------------------------------------------------------------------
# --- STEP 2: DOWNLOAD, CHECK, AND EXTRACT SOURCE DATA ---
# ----------------------------------------------------------------------

# Function to check for dependencies, handle the OS file download, and extract it
handle_software_download_and_extract() {
    echo "=========================================="
    echo "  Step 2: Check, Download, & Extract Data"
    echo "=========================================="

    # --- Dependency Check Helper Function ---
    install_dependency() {
        local dep_name=$1
        local package_info=${DEPENDENCIES[$dep_name]}
        local package_apt=$(echo "$package_info" | awk '{print $1}')
        local package_dnf=$(echo "$package_info" | awk '{print $2}')
        
        if ! command -v "$dep_name" &> /dev/null; then
            echo "$dep_name is not found. Attempting to install required dependency..."
            
            if command -v apt &> /dev/null; then
                # Debian/Ubuntu systems
                apt update && apt install "$package_apt" -y
            elif command -v dnf &> /dev/null; then
                # Fedora/RHEL/CentOS systems
                dnf install "$package_dnf" -y
            elif command -v pacman &> /dev/null; then
                # Arch/Manjaro systems
                echo "Detected pacman. Installing $dep_name using pacman..."
                pacman -Sy --noconfirm "$package_dnf" 
            else
                echo "Error: Cannot find 'apt', 'dnf', or 'pacman'. Please install $dep_name manually (e.g., wget, 7z) to continue."
                return 1
            fi
            
            if ! command -v "$dep_name" &> /dev/null; then
                 echo "Error: Failed to install $dep_name. Please check your package manager."
                 return 1
            fi
            echo "$dep_name installed successfully."
        fi
        return 0
    }
    # ----------------------------------------
    
    # 1. Install Dependencies (wget, 7z)
    for command_name in "${!DEPENDENCIES[@]}"; do
        if ! install_dependency "$command_name"; then return 1; fi
    done

    # 2. Create the installer data directory if it doesn't exist
    if [ ! -d "$INSTALL_DATA_DIR" ]; then
        echo "Creating data directory: $INSTALL_DATA_DIR"
        mkdir -p "$INSTALL_DATA_DIR"
    fi

    # 3. Handle File Check/Download
    if [ -d "$INSTALL_SOURCE_PATH" ]; then
        echo ""
        echo "Extracted source directory ($EXTRACTED_DIR_NAME) already found in $INSTALL_DATA_DIR."
        
        PS3="Choose an action (enter number): "
        select ACTION in "Use Current Extracted Source" "Redownload and Re-extract" "Exit Installer"
        do
            case $REPLY in
                1)
                    echo "Using existing extracted source. Proceeding with installation."
                    return 0
                    ;;
                2)
                    echo "Redownload selected. Deleting old source and archive..."
                    rm -rf "$INSTALL_SOURCE_PATH" "$INSTALL_ARCHIVE_PATH"
                    break 
                    ;;
                3)
                    echo "Action cancelled."
                    return 1
                    ;;
                *)
                    echo "Invalid choice. Please enter 1, 2, or 3."
                    ;;
            esac
        done
    fi

    # 4. Download the archive file 
    if [ ! -f "$INSTALL_ARCHIVE_PATH" ]; then
        echo ""
        echo "Downloading '$ARCHIVE_FILENAME' from source URL..."
        
        # Enhanced wget command: -L (follow redirects), --user-agent (mimic browser), 
        # --content-disposition (use filename suggested by server)
        # Using -O to force the output file name for consistency.
        if ! wget -L --user-agent="Mozilla/5.0" --content-disposition -O "$INSTALL_ARCHIVE_PATH" "$SOFTWARE_DOWNLOAD_URL"; then
            echo ""
            echo "Error: Download failed. Check network connection or the MediaFire URL."
            return 1
        fi
        echo "Download complete! File saved to $INSTALL_ARCHIVE_PATH."
    else
        echo "Archive file already present. Skipping download."
    fi

    # 4.1 Check file integrity (non-zero size check)
    # Check if the downloaded file is less than 1MB (1000000 bytes). This catches small HTML error pages.
    local MIN_SIZE_BYTES=1000000
    local file_size_bytes=$(stat -c%s "$INSTALL_ARCHIVE_PATH" 2>/dev/null)
    
    if [ -z "$file_size_bytes" ] || [ "$file_size_bytes" -lt "$MIN_SIZE_BYTES" ]; then
         echo ""
         echo "Error: Downloaded file is too small ($file_size_bytes bytes). It may be a broken link or a security/warning page."
         echo "Expected file size is greater than 1MB. Deleting small file and stopping installation."
         rm -f "$INSTALL_ARCHIVE_PATH"
         return 1
    fi
    echo "File integrity check passed. Size is acceptable."


    # 5. Extract the archive
    echo ""
    echo "Extracting system files to $INSTALL_DATA_DIR using 7z..."
    if ! 7z x "$INSTALL_ARCHIVE_PATH" -o"$INSTALL_DATA_DIR" > /dev/null; then
        echo ""
        echo "Error: Extraction failed. Ensure '7z' is installed and the archive is valid."
        return 1
    fi
        
    echo "Extraction complete! System files available at $INSTALL_SOURCE_PATH."
    return 0
}


# ----------------------------------------------------------------------
# --- STEP 3: SOFTWARE VERSION SELECTION (Simplified) ---
# ----------------------------------------------------------------------

select_software_version() {
    echo "=========================================="
    echo "  Step 3: Confirm Software Version"
    echo "=========================================="
    
    # Auto-select the only available option
    SOFTWARE_VERSION_ID="EchOS+ Full x64_86"
    
    echo "Version: $SOFTWARE_VERSION_ID"
    echo "Target Installation Directory: $FINAL_INSTALL_DIR"
    echo "Autostart Configuration: $([ "$AUTOSTART_ENABLED" == "true" ] && echo "Enabled" || echo "Skipped")"
    echo "------------------------------------------"
    
    read -r -p "Confirm details and proceed? (y/n): " confirm
    confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
    
    if [[ "$confirm" == "y" || "$confirm" == "yes" ]]; then
        return 0
    else
        echo "Installation cancelled."
        SOFTWARE_VERSION_ID="" 
        return 1
    fi
}


# ----------------------------------------------------------------------
# --- STEP 4: INSTALLATION CORE FUNCTIONS (FILE CREATION IS REAL) ---
# ----------------------------------------------------------------------

# Function to create the autostart files on the host system
configure_autostart_files() {
    if [[ "$AUTOSTART_ENABLED" != "true" ]]; then
        echo "  -> Autostart configuration SKIPPED due to '--noauto' flag."
        return 0
    fi 

    echo "  -> Configuring Autostart files..."
    
    # 1. System Boot Autostart Script (/etc/echos-boot-start.sh)
    local boot_target_path="/etc/echos-boot-start.sh"
    echo "  -> Creating system boot script: $boot_target_path"
    echo "$BOOT_START_SCRIPT_CONTENT" | tee "$boot_target_path" > /dev/null
    chmod +x "$boot_target_path"
    echo "  -> SUCCESS: Created boot script."
    echo "  -> NOTE: You must manually configure your init system (systemd, init.d, etc.) to execute $boot_target_path on boot."


    # 2. Desktop Session Autostart (/root/.xinitrc)
    local xinitrc_target_path="/root/.xinitrc"
    echo "  -> Creating desktop autostart script for root user: $xinitrc_target_path"
    
    # This assumes the user will be running 'startx' as root or the first user's configuration is needed.
    # We must back up any existing .xinitrc before writing a new one.
    if [ -f "$xinitrc_target_path" ]; then
        echo "  -> Warning: Existing $xinitrc_target_path found. Backing up to ${xinitrc_target_path}.bak"
        mv "$xinitrc_target_path" "${xinitrc_target_path}.bak"
    fi
    
    echo "$XINITRC_CONTENT" | tee "$xinitrc_target_path" > /dev/null
    chmod +x "$xinitrc_target_path"
    echo "  -> SUCCESS: Created desktop script."
}


# Main installation sequence function
start_installation() {
    local install_source=$1

    echo "=========================================="
    echo "  Step 4: Beginning Software Installation"
    echo "=========================================="
    
    # 1. Create the final destination directory
    echo "  -> Creating final installation directory: $FINAL_INSTALL_DIR"
    mkdir -p "$FINAL_INSTALL_DIR"

    # 2. Copy the System Files
    echo "  -> Copying EchOS system files from extracted source ($install_source) to $FINAL_INSTALL_DIR..."
    
    # The '-a' flag preserves permissions and is recursive; '.*' copies hidden files too.
    if ! cp -a "$install_source/." "$FINAL_INSTALL_DIR/"; then
        echo "ERROR: File copy failed. Check source permissions or disk space."
        return 1
    fi
    
    echo "  -> File copy complete."

    # 3. Configure Application Autostart Files
    configure_autostart_files

    # 4. Cleanup temporary files
    echo "  -> Cleaning up temporary installation data ($INSTALL_DATA_DIR)..."
    rm -rf "$INSTALL_DATA_DIR"
    
    echo "=========================================="
    echo "INSTALLATION COMPLETE."
    echo "EchOS application files are in $FINAL_INSTALL_DIR."
    echo "=========================================="
    return 0
}


# ------------------------------------------------------------
# MAIN SCRIPT EXECUTION
# ------------------------------------------------------------

echo "Starting EchOS Software Installer Utility."

# 1. Initial Hardware Check
if ! check_hardware_requirements; then
    exit 1
fi
echo ""

# 2. Run Software Version Confirmation
if ! select_software_version; then
    exit 1
fi
echo ""

# 3. Handle Download and Extraction
if ! handle_software_download_and_extract; then
    echo "Download/Extraction failed. Exiting installer."
    exit 1
fi
echo ""

# 4. Final Confirmation and Installation Start
read -r -p "Ready to begin copying files and configuring autostart? (y/n): " final_confirm
final_confirm=$(echo "$final_confirm" | tr '[:upper:]' '[:lower:]')

if [[ "$final_confirm" == "y" || "$final_confirm" == "yes" ]]; then
    # Call the installation function!
    start_installation "$INSTALL_SOURCE_PATH"
    echo "Installation process finished. The application is now installed and configured for autostart (unless --noauto was used)."
else
    echo "Installation cancelled by user."
    exit 1
fi

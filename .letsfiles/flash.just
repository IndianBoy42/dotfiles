# Justfile for STM32 flashing tools
set dotenv-load := true

debug_flag := "-d0" # d3

# Default project name (can be overridden)
project_name := env_var_or_default("CMAKE_PROJECT_NAME", "firmware")

dont_build := env_var_or_default("DONT_BUILD", "false")

binary_suffix := env_var_or_default("CMAKE_EXECUTABLE_SUFFIX", ".elf")
build_dir_abs := invocation_directory() + '/' + env_var_or_default("CMAKE_BINARY_DIR", "build")

# Tool paths
stlinkutil := env_var_or_default("STLINKUTIL", "ST-LINK_CLI")
stflash := env_var_or_default("STUPLOAD_EXE", "st-flash")
stutil := env_var_or_default("STUTIL", "st-util")
stm32cubeprog := env_var_or_default("STM32CubeProg", "STM32_Programmer_CLI")
openocd := env_var_or_default("OPENOCD_EXE", "openocd")
probe_rs := env_var_or_default("PROBE_RS_EXE", "probe-rs")
objcopy := env_var_or_default("CMAKE_OBJCOPY", "arm-none-eabi-objcopy")
objdump := env_var_or_default("CMAKE_OBJDUMP", "arm-none-eabi-objdump")

# Configuration files/parameters
openocd_cfg := env_var_or_default("OPENOCD_CFG", "openocd.cfg")
gdb_debug_file := env_var_or_default("GDB_DEBUG_FILE", "debug.gdb")
probe_rs_chip := env_var_or_default("PROBE_RS_CHIP", "stm32")
probe_rs_protocol := env_var_or_default("PROBE_RS_PROTOCOL", "swd")

# Default programmer selection
default_programmer := env_var_or_default("DEFAULT_PROGRAMMER", "probe_rs")
upload_default := "upload_" + default_programmer
reset_default := "reset_" + default_programmer
download_default := "download" + default_programmer
erase_default := "erase_" + default_programmer
debug_default := "debug_" + default_programmer

# Detect OS for BlackMagic Probe
os := os()

# Default recipes based on programmer preference
upload: 
  just --justfile {{justfile()}} {{upload_default}}

reset: 
  just --justfile {{justfile()}} {{reset_default}}

erase: 
  just --justfile {{justfile()}} {{erase_default}}

debug: 
  just --justfile {{justfile()}} {{debug_default}}

[no-cd]
gdb: gdb_openocd

# Build targets
[no-cd]
build:
    @echo "Building {{build_dir_abs}}/{{project_name}}"
    {{dont_build}} || cmake --build {{build_dir_abs}}

# Generate HEX file
[no-cd]
hex: build
    @echo "Building HEX File"
    {{objcopy}} -Oihex {{build_dir_abs}}/{{project_name}}{{binary_suffix}} {{build_dir_abs}}/{{project_name}}.hex

# Generate BIN file
[no-cd]
bin: build
    @echo "Building BIN File"
    {{objcopy}} -Obinary {{build_dir_abs}}/{{project_name}}{{binary_suffix}} {{build_dir_abs}}/{{project_name}}.bin

# STM32CubeProgrammer targets
[no-cd]
upload_cubeprog: build
    @echo "Upload target hardware (by STM32CubeProgrammer)"
    {{stm32cubeprog}} \
    -c port=SWD -w {{build_dir_abs}}/{{project_name}}{{binary_suffix}} -g

[no-cd]
upload_uart: build
    @echo "Upload target hardware (by UART)"
    {{stm32cubeprog}} \
    -c port=/dev/ttyACM0 -w {{build_dir_abs}}/{{project_name}}{{binary_suffix}} -g

[no-cd]
upload_usb: build
    @echo "Upload target hardware (by USB DFU)"
    {{stm32cubeprog}} \
    -c port=usb0 -w {{build_dir_abs}}/{{project_name}}{{binary_suffix}} -g

[no-cd]
erase_cubeprog:
    @echo "Mass Erase all flash sectors"
    {{stm32cubeprog}} \
    -c port=SWD -e all

[no-cd]
debug_cubeprog:
    @echo "Debug server unimplemented for Cube Programmer"

[no-cd]
gdb_cubeprog:
    @echo "GDB unimplemented for Cube Programmer"

# OpenOCD targets
[no-cd]
reset_openocd: 
    @echo "Upload target hardware (by OpenOCD)"
    {{openocd}} -f {{openocd_cfg}} {{debug_flag}} \
    -c "init" \
    -c "reset halt" \
    -c "flash probe 0" \
    -c "flash info 0" \
    -c "reset run" \
    -c "shutdown"

[no-cd]
upload_openocd: build
    @echo "Upload target hardware (by OpenOCD)"
    {{openocd}} -f {{openocd_cfg}} \
    -c "init" \
    -c "reset halt" \
    -c "flash write_image erase {{build_dir_abs}}/{{project_name}}{{binary_suffix}}" \
    -c "reset run" \
    -c "shutdown"

[no-cd]
debug_openocd: build
    @echo "Running OpenOCD as a GDB host (port 3333)"
    {{openocd}} -f {{openocd_cfg}}

[no-cd]
gdb_openocd: build
    gdbgui -g arm-none-eabi-gdb {{build_dir_abs}}/{{project_name}}{{binary_suffix}} --gdb-cmd='-x {{gdb_debug_file}}'

[no-cd]
erase_openocd: 
    @echo "Mass Erase all flash sectors"
    {{openocd}} -f {{openocd_cfg}} \
    -c "init" \
    -c "reset halt" \
    -c "flash erase_sector 0 0 last" \
    -c "shutdown"

# Probe-rs (cargo_embed) targets
[no-cd]
reset_probe_rs: 
    @echo "Upload target hardware (by Probe-rs)"
    {{probe_rs}} reset --chip {{probe_rs_chip}} --protocol {{probe_rs_protocol}} 

[no-cd]
upload_probe_rs: build
    @echo "Upload target hardware (by Probe-rs)"
    {{probe_rs}} download --chip {{probe_rs_chip}} --protocol {{probe_rs_protocol}} {{build_dir_abs}}/{{project_name}}{{binary_suffix}} 

[no-cd]
debug_probe_rs: build
    @echo "Running Probe-rs as a standalone debugger"
    {{probe_rs}} debug --chip {{probe_rs_chip}} --protocol {{probe_rs_protocol}} {{build_dir_abs}}/{{project_name}}{{binary_suffix}} 

[no-cd]
gdb_probe_rs: build
    {{probe_rs}} gdb --chip {{probe_rs_chip}} --protocol {{probe_rs_protocol}} {{build_dir_abs}}/{{project_name}}{{binary_suffix}} 

[no-cd]
erase_probe_rs: 
    @echo "Mass Erase all flash sectors"
    {{probe_rs}} erase --chip {{probe_rs_chip}} --protocol {{probe_rs_protocol}} {{build_dir_abs}}/{{project_name}}{{binary_suffix}}  --help

# BlackMagic Probe targets
[no-cd]
upload_blackmagic: build
    @echo "Upload target hardware (by BMP)"
    @if [[ "{{os}}" != "windows" ]]; then \
        arm-none-eabi-gdb {{build_dir_abs}}/{{project_name}}{{binary_suffix}} -ex 'target extended-remote /dev/cu.usbmodemB5D699FD1' -ex 'monitor swdp_scan' -ex 'att 1' -ex 'load' -ex 'compare-sections' -ex 'set confirm off' -ex 'quit'; \
    else \
        arm-none-eabi-gdb {{build_dir_abs}}/{{project_name}}{{binary_suffix}} -ex 'target extended-remote COM' -ex 'att 1' -ex 'load' -ex 'compare-sections' -ex 'set confirm off' -ex 'quit'; \
    fi

# Analysis targets
[no-cd]
listing: build
    @echo "Dumping Memory Listing"
    {{objdump}} -d -r -S -l -w -h -t -x -marmv7 {{build_dir_abs}}/{{project_name}}{{binary_suffix}} > {{build_dir_abs}}/{{project_name}}.lst

[no-cd]
asm: build
    @echo "Dumping Assembly"
    {{objdump}} -d -S -marmv7 {{build_dir_abs}}/{{project_name}}{{binary_suffix}} > {{build_dir_abs}}/{{project_name}}.s

# TODO: autodetect rtt, usb, uart, etc
[no-cd]
term:
    rtt2pty --chip {{probe_rs_chip}}

# List available targets
list:
    @echo "Available targets:"
    @echo "  Build targets:"
    @echo "    build     - Build the project"
    @echo "    hex       - Generate HEX file"
    @echo "    bin       - Generate BIN file"
    @echo ""
    @echo "  Upload targets:"
    @echo "    upload              - Upload using default programmer"
    @echo "    upload_stlinkutil   - Upload using STLink Utility"
    @echo "    upload_stflash      - Upload using st-flash"
    @echo "    upload_cubeprog     - Upload using STM32CubeProgrammer"
    @echo "    upload_openocd      - Upload using OpenOCD"
    @echo "    upload_blackmagic   - Upload using BlackMagic Probe"
    @echo "    upload_uart         - Upload using UART"
    @echo "    upload_usb          - Upload using USB DFU"
    @echo ""
    @echo "  Erase targets:"
    @echo "    erase               - Erase using default programmer"
    @echo "    erase_stlinkutil    - Erase using STLink Utility"
    @echo "    erase_stflash       - Erase using st-flash"
    @echo "    erase_cubeprog      - Erase using STM32CubeProgrammer"
    @echo "    erase_openocd       - Erase using OpenOCD"
    @echo ""
    @echo "  Debug targets:"
    @echo "    debug               - Start debug server"
    @echo "    debug_stutil        - Debug using st-util"
    @echo "    debug_openocd       - Debug using OpenOCD"
    @echo "    gdb                 - Start GDB with GUI"
    @echo "    gdb_openocd         - Start GDB with OpenOCD"
    @echo ""
    @echo "  Analysis targets:"
    @echo "    listing             - Generate memory listing"
    @echo "    asm                 - Generate assembly dump"

# STLink Utility targets
[no-cd]
upload_stlinkutil: hex
    @echo "Upload target hardware (by STLink Utility CLI)"
    {{stlinkutil}} \
    -c -P {{build_dir_abs}}/{{project_name}}.hex -Rst -Run

[no-cd]
erase_stlinkutil:
    @echo "Mass Erase all flash sectors"
    {{stlinkutil}} \
    -c -ME

# ST-Flash (Texane/STlink) targets
[no-cd]
upload_stflash: hex
    @echo "Upload target hardware (by Texane/STlink) (Remember to reset to run the program)"
    {{stflash}} --reset --format ihex write {{build_dir_abs}}/{{project_name}}.hex

[no-cd]
erase_stflash:
    @echo "Mass Erase all flash sectors"
    {{stflash}} erase

[no-cd]
debug_stutil: build
    @echo "Running ST-UTIL as a GDB host (port 3333)"
    {{stutil}} -m -p 3333

# Clean generated files
clean:
    rm -f {{build_dir_abs}}/{{project_name}}.hex {{build_dir_abs}}/{{project_name}}.bin {{build_dir_abs}}/{{project_name}}.lst {{build_dir_abs}}/{{project_name}}.s

#!/usr/bin/env bash
# Runs *inside* the arch container, started by `lets distrobox check` (see ../distrobox.just).
# $HOME is shared, so the container reads this file straight from the host.
#
# Every workload gets a version dump *and* something that actually compiles or evaluates:
# a binary that answers --version can still fail to link, which is exactly how a container
# toolchain breaks quietly.
set -o pipefail

section() { printf '\n=== %s ===\n' "$1"; }
ok()      { printf '  %s: OK\n' "$1"; }

section "go + html/js"
go version
node --version
pnpm --version
bun --version
rm -rf /tmp/gochk && mkdir -p /tmp/gochk && cd /tmp/gochk
go mod init gochk >/dev/null 2>&1
printf 'package main\n\nfunc main() { println("ok") }\n' > main.go
go build -o /tmp/gochk/gochk . && ok "go build"
node -e 'console.log("  node eval: OK")'
bun -e 'console.log("  bun eval: OK")'

section "rust (cli + gui)"
cargo --version
rustc --version
rm -rf /tmp/rustchk && cargo new -q /tmp/rustchk && cd /tmp/rustchk
# exercises the shared ~/.cargo/config.toml, which pins `linker = "clang"` and -fuse-ld=wild
cargo build -q && ok "cargo build"
for m in gtk4 libadwaita-1 webkit2gtk-4.1; do
    printf '  %-18s %s\n' "$m" "$(pkg-config --modversion "$m")"
done

section "c/c++ embedded"
arm-none-eabi-gcc --version | head -1
riscv64-elf-gcc --version | head -1
probe-rs --version
openocd --version 2>&1 | head -1
tio --version
esptool version | head -1
st-info --version 2>&1 | head -1
printf 'int main(void) { return 0; }\n' > /tmp/embchk.c
arm-none-eabi-gcc -c /tmp/embchk.c -o /tmp/embchk.o && ok "arm-none-eabi-gcc compile"
riscv64-elf-gcc -c /tmp/embchk.c -o /tmp/embchk.o && ok "riscv64-elf-gcc compile"

section "python datascience"
python --version
python -c 'import numpy, pandas, scipy, matplotlib, sklearn, polars
print("  numpy", numpy.__version__, "| pandas", pandas.__version__, "| scipy", scipy.__version__, "| sklearn", sklearn.__version__, "| polars", polars.__version__)'
jupyter lab --version | sed 's/^/  jupyterlab /'
uv --version | sed 's/^/  uv /'
# uv keeps its own CPython builds and a bare `--python python3` request resolves to one of
# those (~/.local/share/uv/python), so the container's interpreter is named explicitly here.
rm -rf /tmp/uvchk && uv venv -q --python /usr/bin/python3 /tmp/uvchk && /tmp/uvchk/bin/python -c 'import sys; print("  uv venv python", sys.version.split()[0])'

section "gpu passthrough"
if vulkaninfo --summary >/tmp/vk.txt 2>&1; then
    grep -E 'deviceName|driverName' /tmp/vk.txt | head -2 | sed 's/^ */  /'
else
    printf '  vulkaninfo failed — /dev/dri may not be passed through\n'
fi

section "terminal"
printf '  TERM=%s\n' "$TERM"
# Asserted with -T so it does not depend on the caller's TERM, and *not* via $TERMINFO: the
# point is that the container can resolve xterm-kitty on its own, for the commands that lose
# TERMINFO (sudo, su, a nested login).
if tput -T xterm-kitty colors >/dev/null 2>&1; then
    ok "xterm-kitty terminfo (tput colors = $(tput -T xterm-kitty colors))"
else
    printf '  xterm-kitty terminfo: MISSING — install kitty-terminfo (see arch.ini)\n'
fi

#!/usr/bin/env fish

if not type -q npm
	nvm use --lts
end
if type -q npm
if not type -q xpm
	npm install --global xpm@latest
end
end
if type -q xpm
	xpm install --global @xpack-dev-tools/arm-none-eabi-gcc@latest
	xpm install --global @xpack-dev-tools/riscv-none-embed-gcc@latest
	xpm install --global @xpack-dev-tools/qemu-arm@latest
end

# Enter the arch dev container.
#
# A bare `arch` goes through `kitten run-shell` when it is running inside a kitty window. That
# kitten is what gives the container's shell kitty's prompt marks, cwd/window-title reporting,
# click-to-move-cursor and clone-in-kitty: `distrobox enter` on its own starts a plain login
# shell, and kitty can only inject its integration into a shell that kitty itself started.
# `kitten` is on the container's PATH because ~/.local/bin comes in through the shared $HOME.
#
# Arguments keep the previous behaviour exactly — `arch cargo build` is still
# `distrobox enter arch -- cargo build`, since a one-shot command has no shell to integrate.
#
# `KITTY_WINDOW_ID` is the test for "inside kitty": kitty sets it (along with the rest of the
# KITTY_* variables) for the shell it launches, and it survives the trip into the container.
function arch --description 'Enter the arch dev container (kitty shell integration when in kitty)'
    if test (count $argv) -gt 0
        distrobox enter arch -- $argv
    else if set -q KITTY_WINDOW_ID
        distrobox enter arch -- kitten run-shell
    else
        distrobox enter arch
    end
end

function man

  # Colors for Man Pages
  set -xU LESS_TERMCAP_mb (tput blink)              # begin blinking mode
  set -xU LESS_TERMCAP_md (tput setaf 3)            # begin bold mode (yellow)
  set -xU LESS_TERMCAP_me (tput sgr0)               # end mode
  set -xU LESS_TERMCAP_so (tput bold; tput setaf 8) # begin standout-mode - info box (less visible)
  set -xU LESS_TERMCAP_se (tput sgr0)               # end standout-mode
  set -xU LESS_TERMCAP_us (tput setaf 2)            # begin underline (green)
  set -xU LESS_TERMCAP_ue (tput sgr0)               # end underline
  set -xU LESS_TERMCAP_mr (tput rev)                # negative
  set -xU LESS_TERMCAP_mh (tput dim)                # diminished
  set -xU LESS_TERMCAP_ZN (tput ssubm)
  set -xU LESS_TERMCAP_ZV (tput rsubm)
  set -xU LESS_TERMCAP_ZO (tput ssupm)
  set -xU LESS_TERMCAP_ZW (tput rsupm)

  command man $argv

end

# Fedora-atomic package management (replaces the retired nala/apt abbreviations)
abbr -a os rpm-ostree
abbr -a oss 'rpm-ostree status'
abbr -a osi 'sudo rpm-ostree install'
abbr -a osu 'sudo rpm-ostree upgrade'
abbr -a fp flatpak
abbr -a fpi 'flatpak install --or-update flathub'
abbr -a fpu 'flatpak update'
abbr -a fpapps 'flatpak list --app --columns=application,name'
abbr -a bb 'brew bundle'
abbr -a bl 'brew list'
abbr -a bu 'brew upgrade'
if type -q distrobox
    abbr -a dbx distrobox
    abbr -a dbxl 'distrobox list'
end

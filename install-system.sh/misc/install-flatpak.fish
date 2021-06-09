#!/usr/bin/env fish

if not type -q flatpak
    sudo apt install flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
end
flatpak install com.spotify.Client \
com.anydesk.Anydesk \
org.gimp.GIMP \
org.inkscape.Inkscape \
io.bit3.WhatsAppQT \
org.kde.kdenlive \
org.telegram \
com.discordapp.Discord \
org.signal.Signal \
org.videolan.VLC

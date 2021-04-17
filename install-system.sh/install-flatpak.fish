#!/usr/bin/env fish

if not type -q flatpak
    sudo apt install flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
end
flatpak install -y com.spotify.Client com.anydesk.Anydesk org.gimp.GIMP org.inkscape.Inkscape

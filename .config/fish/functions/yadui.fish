# Defined in /tmp/fish.6N7dXb/yadui.fish @ line 2
function yadui --wraps=gitui --description 'open gitui in the YADM repo'
    if test -d ~/.config/yadm/repo.git
        gitui -d ~/.config/yadm/repo.git
    else
        gitui -d ~/.local/share/yadm/repo.git
    end
end

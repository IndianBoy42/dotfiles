# Defined interactively
function yadui --wraps=gitui --description 'open gitui in the YADM repo'
    gitui -d ~/.config/yadm/repo.git
end

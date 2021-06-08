# Defined interactively
function minvim --wraps=nvim --description 'Lightweight minimal nvim config'
nvim -u minimal.init.lua --noplugin
end

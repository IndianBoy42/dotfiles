# Defined interactively
function py-check-import --description 'Check if can import a library in python'
/usr/bin/env python -c "import $argv as x; print(x.__path__)"
end

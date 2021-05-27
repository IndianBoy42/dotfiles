# Defined interactively
function ghdl --description 'download from github release'
    gh release -R $argv[1] download -p $argv[2] $argv[3..-1]
end

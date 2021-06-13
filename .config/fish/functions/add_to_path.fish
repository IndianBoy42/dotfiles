# Defined interactively
function add_to_path --description 'Add to a PATH like variable with deduplication'
    if test (count $argv) -le 2
        return 1
    end

    if not contains "$argv[1]" $$argv[2]
        set -gxa $argv[2] "$argv[1]"
    end
end

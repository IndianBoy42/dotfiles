function last-function-name --argument index
    history --prefix func | grep -w -E '^(function|funced)' | string replace -- ' -s ' ' ' | awk 'NF>1' | row 1 | coln 2
end

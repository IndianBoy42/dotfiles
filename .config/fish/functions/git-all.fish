function git-all
    ls | xargs -P (nproc) -I{} git -C {} "$argv"
end

# set CONDA_ENVS (conda env list --json | jq '.envs[] | select(test("env")) | split("/") | .[-1]' -r)
set CONDA_ENVS (find ~/anaconda3/envs/ -maxdepth 1 -type d | tail -n+2 | xargs -i basename "{}" )
set EXTRA_CMDS "update" "list" 
set CONDA_CMDS "install" "run" "remove" "clean" "update" "activate"
function conda-abbrs
    set abbr $argv
    for cmd in $CONDA_CMDS
        abbr -g "$abbr-$cmd" "conda $cmd -n $abbr"
    end
end
for abbr in $CONDA_ENVS
    conda-abbrs $abbr
end
function conda-new-env 
    conda create -n $argv python
    conda-abbrs $argv[1]
end

# set CONDA_ENVS (conda env list --json | jq '.envs[] | select(test("env")) | split("/") | .[-1]' -r)
mkdir -p ~/anaconda3/envs
set CONDA_ENVS (find ~/anaconda3/envs/ -maxdepth 1 -type d | tail -n+2 | xargs -i basename "{}" )
set EXTRA_CMDS "update" "list" 
set CONDA_CMDS "install" "run" "remove" "clean" "update"
function conda-abbrs
    set env $argv
    for cmd in $CONDA_CMDS
        abbr -g "$env-$cmd" "conda $cmd -n $env"
    end
    abbr -g "$env-$cmd" "conda $cmd $env"
end
for env in $CONDA_ENVS
    conda-abbrs $env
end
function conda-new-env 
    conda create -n $argv python
    conda-abbrs $argv[1]
end

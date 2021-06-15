set CONDA_ENVS (conda env list --json | jq '.envs[] | select(test("env")) | split("/") | .[-1]' -r)
set CONDA_ABBRS (conda env list --json | jq '.envs[] | select(test("env")) | split("/") | .[-1] | "py-\(.)"' -r)
set -g CONDA_CMDS "install" "run" "update" "list" "remove" "clean" "update"
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

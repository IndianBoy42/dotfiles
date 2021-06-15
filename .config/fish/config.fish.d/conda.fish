set CONDA_ENVS (conda env list --json | jq '.envs[] | select(test("env")) | split("/") | .[-1]' -r)
set CONDA_ABBRS (conda env list --json | jq '.envs[] | select(test("env")) | split("/") | .[-1] | "py-\(.)"' -r)
set CONDA_CMDS "install" "run" "update" "list" "remove" "clean" "update"
for abbr in $CONDA_ENVS
    for cmd in $CONDA_CMDS
        abbr -g "$abbr-$cmd" "conda $cmd -n $abbr"
    end
end

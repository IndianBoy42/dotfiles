wd := invocation_directory()

export VIRTUAL_ENV_DIR := `echo $VIRTUAL_ENV_DIR`

@_default: 
    just -f {{justfile()}} -l

create:
    command python3 -m venv $VIRTUAL_ENV_DIR
    source (string join / $PWD $VIRTUAL_ENV_DIR 'bin/activate.fish')
    pip install -U pip setuptools wheel ipython 
    python -m ipykernel install --user --name (basename $PWD) --display-name "kernel "(basename $PWD)

activate name=VIRTUAL_ENV_DIR:
    source (string join / $PWD {{name}} 'bin/activate.fish')

wd := invocation_directory()

export VIRTUAL_ENV_DIR := `echo $VIRTUAL_ENV_DIR`

@_default: 
    just -f {{justfile()}} -l

create name=VIRTUAL_ENV_DIR:
    command python3 -m venv {{name}}
    source (string join / $PWD {{name}} 'bin/activate.fish')
    pip install -U pip setuptools wheel 
    {{justrun}} install-ipython

activate name=VIRTUAL_ENV_DIR:
    source (string join / $PWD {{name}} 'bin/activate.fish')

install-ipython:
    pip install -U pip ipython 
    python -m ipykernel install --user --name (basename $PWD) --display-name "kernel "(basename $PWD)


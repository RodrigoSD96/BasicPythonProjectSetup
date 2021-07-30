#!/bin/bash
echo 'Please add the project name'
read project_name
poetry new $project_name
cd $project_name
echo 'Please add the desired python version'
read python_version
pyenv update
pyenv install $python_version
pyenv local $python_version
poetry env use python
poetry add --dev pytest-cov pre-commit flake8 mypy isort
poetry add --dev --allow-prereleases black
poetry shell

echo "[tool.isort]
multi_line_output = 3
include_trailing_comma = true
force_grid_wrap = 0
use_parentheses = true
line_length = 120

[tool.black]
line-length = 120
target-version = ['py38']
include = '\.pyi?$'
exclude = '''

(
  /(
      \.eggs         # exclude a few common directories in the
    | \.git          # root of the project
    | \.hg
    | \.mypy_cache
    | \.tox
    | \.venv
    | _build
    | buck-out
    | build
    | dist
  )/
  | foo.py           # also separately exclude a file named foo.py in
                     # the root of the project
)
'''" >> pyproject.toml

echo "[flake8]
extend-ignore = E203

[mypy]
follow_imports = silent
strict_optional = True
warn_redundant_casts = True
warn_unused_ignores = True
disallow_any_generics = True
check_untyped_defs = True
no_implicit_reexport = True
disallow_untyped_defs = True
ignore_missing_imports = True

[mypy-tests.*]
ignore_errors = True" > setup.cfg

echo "repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v3.4.0
    hooks:
    -   id: trailing-whitespace
    -   id: end-of-file-fixer
    -   id: check-yaml
    -   id: check-added-large-files
-   repo: https://gitlab.com/pycqa/flake8
    rev: 3.8.4
    hooks:
    -   id: flake8
-   repo: https://github.com/psf/black
    rev: 20.8b1
    hooks:
      - id: black
-   repo: https://github.com/pre-commit/mirrors-mypy
    rev: v0.812
    hooks:
        - id: mypy
          additional_dependencies: [pydantic]  # add if use pydantic
-   repo: https://github.com/PyCQA/isort
    rev: 5.7.0
    hooks:
    -   id: isort" > .pre-commit-config.yaml

echo '.coverage' > .gitignore
echo '.vscode/\n.idea/' >> .gitignore
curl -s https://raw.githubusercontent.com/github/gitignore/master/Python.gitignore >> .gitignore
git init -b main
git add .
git commit -m 'Initial commit'
pre-commit install
pre-commit autoupdate
pre-commit run --all-files
pre-commit run --all-files

echo 'SETUP COMPLETED'

#!/bin/bash

python3 -mpip --install --user --upgrade pip glances flake8 flake8-docstrings pylint

{{- if eq .chezmoi.os "darwin" }}
python3 -mpip --install --user --upgrade "xonsh[mac]"
{{- if eq .chezmoi.os "linux" }}
python3 -mpip --install --user --upgrade "xonsh[linux]"
{{- end }}


python3 -mpip --install --user --upgrade repassh xontrib-pyenv xontrib-readable-traceback xontrib-ssh-agent xontrib-kitty xontrib-readable-traceback xontrib-ssh-agent



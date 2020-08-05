#!/bin/bash

tmpfile = $(mktemp)
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $tmpfile
sh $tmpfile ~/.cache/dein
# yeah could leak in a crash but it's not a big deal, it's one file rarely run
rm -f $tmpfile


{{- if eq .chezmoi.os "darwin" }}
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install pyenv
{{ else if eq .chezmoi.os "linux" -}}
#this should be tuned for non-debian systems too
#min reqs for pyenv
sudo apt-get update; sudo apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
curl https://pyenv.run | bash
{{- end }}

#node
curl -sL install-node.now.sh | sh

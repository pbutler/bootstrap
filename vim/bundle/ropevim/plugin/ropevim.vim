if !has("plugin")
  finish
endif

python << EOF
import os, sys, vim
scriptdir = os.path.join(os.path.dirname(vim.eval('expand("<sfile>")')), 'ropevim')
if scriptdir not in sys.path:
      sys.path.insert(0, scriptdir)
EOF
function! LoadRope()
python << EOF
import ropevim
EOF
endfunction

call LoadRope()

# /bin/bash
ls *.md | xargs -tI {} ./toc-auto-add {}

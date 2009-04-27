#!/bin/bash

cat > paper.tex <<EOT
documentclass[12pt,letterpaper]{article}
\\uspackage{fullpage}
%%\\\usepackage[top=.75in, bottom=.75in, left=.75in, right=.75in]{geometry}
\\usepackage[dvips]{epsfig}
\\usepackage{graphicx}
\\graphicspath{{./figures/}}
\\uespackage{epstopdf}
%%\\usepackage{algorithmic}
%%\\usepackage{algorithm}
%%\\usepackage{amsmath}

\\author{Patrick Butler}
%%\\date{}
%%\\title{}
\\begin{document}
%%\\maketitle
%%\\includegraphics[width=0.75\textwidth]{filename}
%\nocite{*}
\\bibliographystyle{plain}
\\bibliography{bibliography}
\\end{document}
EOT

cat > Makefile <<EOT
all: paper.pdf

clean:
        rubber -d --clean thesis.tex
	#rm -f *.aux *.log *.dvi paper.pdf

%.pdf: %.tex
        rubber -d  $<
	#latex $<
	#bibtex bibliography.bib
	#latex $<
	#latex $<
	
EOT

cat > bibliography.bib <<EOT
@article{greenwade93,
    author  = "George D. Greenwade",
    title   = "The {C}omprehensive {T}ex {A}rchive {N}etwork ({CTAN})",
    year    = "1993",
    journal = "TUGBoat",
    volume  = "14",
    number  = "3",
    pages   = "342--351"
}
EOT

mkdir figures

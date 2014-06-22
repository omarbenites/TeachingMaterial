LATEXFILES = *.aux\
        *.bbl\
        *.vrb\
	*.nav\
	*.snm\
        *.blg\
        *.ilg\
        *.log\
        *.nlo\
        *.nls\
        *.toc\
        *.aux\
	.Rhistory\
	Rplots.pdf\
	*.tex\
	*.dvi\
	*.map\
        *.out\
	*.tikz\

.PHONY: clean allclean dist

all:
	make R-Basics.pdf
	make StangleAll

setvars:
ifeq (${R_HOME},)
R_HOME=	$(shell R RHOME)
endif

R-Basics.pdf: R-Basics.tex 
	pdflatex R-Basics.tex

R-Basics.tex: Sec-Intro.tex Sec-DataTypes.tex Sec-Programming.tex Sec-RBioc.tex Sec-Packages.tex Sec-Manip.tex Sec-Useful.tex Sec-Plotting.tex R-Basics.Rnw
	"$(R_HOME)/bin/R" --vanilla -e "library(knitr); knit2pdf('R-Basics.Rnw');"
	pdflatex R-Basics.tex

%tex: %Rnw
	"$(R_HOME)/bin/R" --vanilla -e "library(knitr); knit('$*Rnw');"

# Sec-Intro.tex: Sec-Intro.Rnw
# 	"$(R_HOME)/bin/R" --vanilla -e "library(knitr); knit('Sec-Intro.Rnw');"

# Sec-DataTypes.tex: Sec-DataTypes.Rnw
# 	"$(R_HOME)/bin/R" --vanilla -e "library(knitr); knit('Sec-DataTypes.Rnw');"

# Sec-Programming.tex: Sec-Programming.Rnw
# 	"$(R_HOME)/bin/R" --vanilla -e "library(knitr); knit('Sec-Programming.Rnw');"

# Sec-RBioc.tex: Sec-RBioc.Rnw
# 	"$(R_HOME)/bin/R" --vanilla -e "library(knitr); knit('Sec-RBioc.Rnw');"

# Sec-Packages.tex: Sec-Packages.Rnw
# 	"$(R_HOME)/bin/R" --vanilla -e "library(knitr); knit('Sec-Packages.Rnw');"

# Sec-Manip.tex: Sec-Manip.Rnw
# 	"$(R_HOME)/bin/R" --vanilla -e "library(knitr); knit('Sec-Manip.Rnw');"

# Sec-Useful.tex: Sec-Useful.Rnw
# 	"$(R_HOME)/bin/R" --vanilla -e "library(knitr); knit('Sec-Useful.Rnw');"

# Sec-Plotting.tex: Sec-Plotting.Rnw
# 	"$(R_HOME)/bin/R" --vanilla -e "library(knitr); knit('Sec-Plotting.Rnw');"

dist:
	mkdir -p R-Basics/.
	cp R-Basics.pdf R-Basics.R R-Basics/.
	cp -r RefCards R-Basics/.
	cp -r Data R-Basics/.
	cp README.md R-Basics/.
	zip R-Basics.zip R-Basics/*

clean:
	rm -f $(LATEXFILES)
	rm -f *~
	rm -rf figure
	rm -f Data/data.rda
	rm -r R-Basics
	rm R-Basics.zip

StangleAll:
	"$(R_HOME)/bin/R" --vanilla -e "sapply(dir(pattern = 'Rnw'), knitr::purl)"
	cat Sec-Intro.R Sec-DataTypes.R Sec-Manip.R Sec-Useful.R Sec-Plotting.R Sec-Programming.R Sec-Packages.R Sec-RBioc.R > R-Basics.R

# Makefile for CQUThesis
# Adapted from Thuthesis Makefile

# Compiling method: latexmk/xelatex/pdflatex
METHOD = latexmk
# Set opts for latexmk if you use it
LATEXMKOPTS = -xelatex -quiet -halt-on-error -interaction=nonstopmode
# Basename of thesis
THESISMAIN = main


PACKAGE=cquthesis
SOURCES=$(PACKAGE).ins $(PACKAGE).dtx
THESISCONTENTS=$(THESISMAIN).tex contents/*.tex $(FIGURES)
# NOTE: update this to reflect your local file types.
# 注意：下列内容可能需要根据你的实际情况调整
FIGURES=$(wildcard figures/*.eps figures/*.pdf figures/*.jpg  figures/*.jpeg figures/*.png)
BIBFILE=ref/refs.bib
SHUJICONTENTS=$(SHUJIMAIN).tex
CLSFILES=dtx-style.sty $(PACKAGE).cls $(PACKAGE).cfg

# make deletion work on Windows
ifdef SystemRoot
	RM = del /Q
	OPEN = start
else
	RM = rm -f
	OPEN = open
endif

.PHONY: all clean cleanall cls check doc distclean thesis viewthesis viewdoc FORCE_MAKE

all: doc thesis

cls: $(CLSFILES)

doc: $(PACKAGE).pdf

$(CLSFILES): $(SOURCES)
	latex $(PACKAGE).ins

viewdoc: doc
	$(OPEN) $(PACKAGE).pdf

viewthesis: thesis
	$(OPEN) $(THESISMAIN).pdf

thesis: $(THESISMAIN).pdf

ifeq ($(METHOD),latexmk)

$(PACKAGE).pdf: $(CLSFILES)
	xelatex -quiet -halt-on-error -interaction=nonstopmode $(PACKAGE).dtx
	makeindex -s gind.ist -o $(PACKAGE).ind $(PACKAGE).idx
	makeindex -s gglo.ist -o $(PACKAGE).gls $(PACKAGE).glo
	xelatex -quiet -halt-on-error -interaction=nonstopmode $(PACKAGE).dtx
	xelatex -quiet -halt-on-error -interaction=nonstopmode $(PACKAGE).dtx
	xelatex -quiet -halt-on-error -interaction=nonstopmode $(PACKAGE).dtx

$(THESISMAIN).pdf: $(CLSFILES) $(THESISCONTENTS) $(THESISMAIN).bbl $(BIBFILE)
	$(METHOD) $(LATEXMKOPTS) $(THESISMAIN)
	touch $(THESISMAIN).pdf

else ifneq (,$(filter $(METHOD),xelatex pdflatex))

$(PACKAGE).pdf: $(CLSFILES)
	$(METHOD) $(PACKAGE).dtx
	makeindex -s gind.ist -o $(PACKAGE).ind $(PACKAGE).idx
	makeindex -s gglo.ist -o $(PACKAGE).gls $(PACKAGE).glo
	$(METHOD) $(PACKAGE).dtx
	$(METHOD) $(PACKAGE).dtx
	$(METHOD) $(PACKAGE).dtx

$(THESISMAIN).pdf: $(CLSFILES) $(THESISCONTENTS) $(THESISMAIN).bbl $(BIBFILE)
	$(METHOD) $(THESISMAIN)
	$(METHOD) $(THESISMAIN)
	touch $(THESISMAIN).pdf

$(THESISMAIN).bbl: $(BIBFILE)
	$(METHOD) $(THESISMAIN)
	-bibtex $(THESISMAIN)
	$(RM) $(THESISMAIN).pdf

else
$(error Unknown METHOD: $(METHOD))

endif

clean:
	latexmk -c $(PACKAGE).dtx $(THESISMAIN)
	-@$(RM) *~

cleanall: clean
	-@$(RM) $(PACKAGE).pdf $(THESISMAIN).pdf

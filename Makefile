TEX := uplatex
DVIPDFMX := dvipdfmx
BIB := pbibtex

MAIN := main
ABST := ISEE_abstract
PRE := preamble
COVER := cover_page
COVER2 := cover_page_copy
TEXS := $(wildcard *.tex)
TEXS := $(filter-out $(COVER).tex $(COVER)2.tex $(ABST).tex, $(TEXS))

STYS := $(wildcard *.sty)
FIGS := $(wildcard fig/*)

PDFS := $(wildcard fig/*pdf)
PNGS := $(wildcard fig/*png)

FIGS := $(filter-out fig/*~, $(FIGS))

BBL  := $(MAIN).bbl

.PHONY: all clean

all: $(MAIN).pdf $(ABST).pdf $(COVER).pdf $(COVER2).pdf

%.aux: %.tex
	$(TEX) $(MAIN)

$(BBL): $(MAIN).aux thesis.bib jecon.bst
	$(BIB) $(MAIN)

$(ABST).dvi: $(ABST).tex AuthorInfo.tex $(STYS) $(PRE).tex
	$(TEX)	$(ABST)

$(COVER).dvi: $(COVER).tex AuthorInfo.tex $(STYS) $(PRE).tex
	$(TEX)	$(COVER)

$(COVER2).dvi: $(COVER2).tex AuthorInfo.tex $(STYS) $(PRE).tex
	$(TEX)	$(COVER2)

$(MAIN).dvi: $(TEXS) $(STYS) $(FIGS) $(BBL)
	$(TEX)	$(MAIN)

	if egrep 'No file $(MAIN).toc.' $(MAIN).log;\
	then\
		$(TEX)	$(MAIN);\
	fi

	if egrep 'LaTeX Warning: There were undefined references.' $(MAIN).log;\
	then\
		$(TEX) $(MAIN);\
	fi

	if egrep 'There were undefined citations.' $(MAIN).log;\
	then\
		$(TEX) $(MAIN);\
	fi

$(ABST).pdf: $(ABST).dvi
	$(DVIPDFMX) $^

$(COVER).pdf: $(COVER).dvi
	$(DVIPDFMX) $^

$(COVER2).pdf: $(COVER2).dvi
	$(DVIPDFMX) $^

$(MAIN).pdf: $(MAIN).dvi
	$(DVIPDFMX) $^

clean:
	rm -f *.pdf *.dvi *.aux *.log *.lot *.lof *.out *.toc tex/*.aux *~ src/*~ tex/*~ *.bbl *.blg

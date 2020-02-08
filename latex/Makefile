all: compile biber compile-again
compile-again: cv.tex
	pdflatex $(^)
compile: cv.tex
	pdflatex $(^)
biber:
	biber cv
clean:
	rm -f cv.log cv.dvi cv.pdf cv.bbl cv.bcf cv.blg cv.run.xml cv.aux

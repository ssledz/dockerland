# pdflatex version
```
docker run -it --rm ssledz/pdflatex:latest
```

## building using Makefile

```
docker run -it --rm -v $(pwd):/var/local ssledz/pdflatex:latest make
```

## building using just pdflatex
```
docker run -it --rm -v $(pwd):/var/local ssledz/pdflatex:latest buid sample.tex
```
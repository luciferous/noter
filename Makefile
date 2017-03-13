MD := $(filter-out README.md, $(wildcard *.md))
HTML := $(MD:.md=.html)

all: $(HTML)

clean:
	rm -f $(HTML)

.DELETE_ON_ERROR:

%.html: %.md
	./noter $< > $@

.PHONY: all clean

MD := $(filter-out README.md, $(wildcard *.md))
HTML := $(MD:.md=.html)

all: index.html feed.atom $(HTML)

clean:
	rm -f index.html feed.atom $(HTML)

.DELETE_ON_ERROR:

feed.atom: $(HTML)
	./notes atom $(MD) > $@

index.html: $(HTML)
	./notes index $(MD) > $@

%.html: %.md
	./notes note $< > $@

.PHONY: all clean

MD := $(filter-out README.md index.md, $(wildcard *.md))
HTML := $(MD:.md=.html)
SYSTEM := Makefile notes $(wildcard *.sh)

all: index.html feed.atom $(HTML)

clean:
	rm -f index.html feed.atom $(HTML)

.DELETE_ON_ERROR:

feed.atom: $(HTML) $(SYSTEM)
	./notes atom $(MD) > $@

index.html: index.md $(HTML) $(SYSTEM)
	./notes index $(MD) > $@

%.html: %.md $(SYSTEM)
	./notes note $< > $@

.PHONY: all clean

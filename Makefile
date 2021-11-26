THEMIS := themis/bin/themis
PROFILE := build/vim-profile.txt
COVIMERAGE := covimerage

.PHONY: tests cov clean view

cov: build/htmlcov/index.html

tests: $(PROFILE)

build/htmlcov/index.html: $(PROFILE)
	$(COVIMERAGE) write_coverage $(PROFILE) --data-file build/covimerage
	coverage report -m
	coverage html

view: build/htmlcov/index.html
	/usr/bin/chromium $^


$(PROFILE): $(THEMIS) build/ $(wildcard tests/*.vim) $(wildcard plugin/*.vim) $(wildcard autoload/*.vim)
	THEMIS_PROFILE=$@ $^ --runtimepath $(THEMIS) --runtimepath . --exclude themis -r tests/

$(THEMIS):
	git clone --depth 1 https://github.com/thinca/vim-themis $(THEMIS)

build/:
	mkdir -p build

clean:
	rm -f $(PROFILE)
	rm -rf build/

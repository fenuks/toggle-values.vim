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


$(PROFILE): themis/ build/ $(wildcard tests/*.vim) $(wildcard plugin/*.vim) $(wildcard autoload/*.vim)
	THEMIS_PROFILE=$@ $(THEMIS) --runtimepath themis --runtimepath . --exclude themis/ -r tests/

themis/:
	git clone --depth 1 https://github.com/thinca/vim-themis themis

build/:
	mkdir -p build

clean:
	rm -f $(PROFILE)
	rm -rf build/
	rm -rf themis/

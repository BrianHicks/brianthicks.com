site_deps=$(shell find themes content data layouts static themes)

public: ${site_deps}
	git submodule init
	git submodule update
	hugo

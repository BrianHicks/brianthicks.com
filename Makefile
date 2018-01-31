site_deps=$(shell find themes content layouts static themes)

public: ${site_deps}
	hugo

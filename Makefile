site_deps=$(shell find archetypes themes content data layouts static themes)

public: ${site_deps}
	hugo

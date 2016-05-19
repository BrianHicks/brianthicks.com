site_deps=$(shell find archetypes themes content data layouts static themes)
.PHONY = deploy

public: ${site_deps}
	hugo

deploy:
	terraform apply

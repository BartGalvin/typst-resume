TYPST ?= typst
OUTPUT := output/pdf/Bart_Galvin_CV.pdf
CONTACT_INPUT := $(if $(wildcard contact.private.yaml),--input contacts=contact.private.yaml)

.PHONY: pdf watch

pdf:
	mkdir -p output/pdf
	$(TYPST) compile --root . $(CONTACT_INPUT) cv.typ "$(OUTPUT)"

watch:
	mkdir -p output/pdf
	$(TYPST) watch --root . $(CONTACT_INPUT) cv.typ "$(OUTPUT)"

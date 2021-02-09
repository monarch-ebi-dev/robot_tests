
DATADIR=data
OUTDIR=build
ROBOT=robot
URIBASE=http://purl.obolibrary.org/obo

dirs:
	mkdir -p $(OUTDIR)

$(OUTDIR)/fail-external-1.ofn: $(DATADIR)/fail-external-1.ofn | dirs
	$(ROBOT) filter --input $< \
  --base-iri $(URIBASE)/OMRSE_ \
  --axioms external \
  --preserve-structure false \
  --output $@ && if grep -q $(URIBASE)/OMRSE_ $@; then echo "ROBOT FAIL"; fi

.PHONY: tests
tests: $(OUTDIR)/fail-external-1.ofn
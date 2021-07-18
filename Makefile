
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

$(OUTDIR)/fail-multiple-logical-definitions.tsv: $(DATADIR)/multiple_logical_definitions.ttl
		$(ROBOT) query -i $< --query sparql/multiple_logical_definitions.sparql $@

$(OUTDIR)/fail-report-three-labels.tsv: $(DATADIR)/three_labels.ttl
		$(ROBOT) report -i $< -o $@

$(OUTDIR)/fail-duplicate-definitions.tsv: $(DATADIR)/duplicate_definitions.ttl
		$(ROBOT) query -i $< --query sparql/duplicate_definitions.sparql $@

$(OUTDIR)/fail-illegalbuiltin.tsv:
	$(ROBOT) query -I http://purl.obolibrary.org/obo/obib.owl --query sparql/illegalbuiltin.sparql $@


.PHONY: tests
tests: $(OUTDIR)/fail-external-1.ofn $(OUTDIR)/fail-multiple-logical-definitions.tsv

.PHONY: t
t: $(OUTDIR)/fail-illegalbuiltin.tsv

.PHONY: deprecate_test
deprecate_test: $(DATADIR)/deprecate-use.owl
	$(ROBOT) verify -i $< --queries sparql/deprecate-use.sparql $@
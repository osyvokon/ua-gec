.PHONY: install postprocess m2 check stats


install:
	cd python/ua_gec && ln -sf ../../data data
	cd python && python3 setup.py develop

check:
	./scripts/validate.py

postprocess:
	rm -rf data/gec-*/test/source*
	rm -rf data/gec-*/test/target*
	rm -rf data/gec-*/train/source*
	rm -rf data/gec-*/train/target*
	./scripts/postprocess_dataset.py --annotation-layer gec-fluency
	./scripts/postprocess_dataset.py --annotation-layer gec-only
	bash -c './scripts/normalize_trailing_newslines.py data/gec-{only,fluency}/{test,train}/*/*{.txt,.ann}'

m2:
	./scripts/make_m2.py --partition test --layer gec-fluency --output data/gec-fluency/test/gec-fluency.test.m2
	./scripts/make_m2.py --partition test --layer gec-only --output data/gec-only/test/gec-only.test.m2
	./scripts/make_m2.py --partition train --layer gec-fluency --output data/gec-fluency/train/gec-fluency.train.m2
	./scripts/make_m2.py --partition train --layer gec-only --output data/gec-only/train/gec-only.train.m2

split-sentences: # m2
	./scripts/m2_to_annotated.py ./data/gec-only/test/gec-only.test.m2 	   -o ./data/gec-only/test/gec-only.test.annotated
	./scripts/m2_to_annotated.py --ignore-errors ./data/gec-only/train/gec-only.train.m2 	   -o  ./data/gec-only/train/gec-only.train.annotated
	./scripts/m2_to_annotated.py ./data/gec-fluency/test/gec-fluency.test.m2   -o  ./data/gec-fluency/test/gec-fluency.test.annotated
	./scripts/m2_to_annotated.py ./data/gec-fluency/train/gec-fluency.train.m2 -o  ./data/gec-fluency/train/gec-fluency.train.annotated


stats:
	./python/ua_gec/stats.py all gec-fluency | tee stats.gec-fluency.txt
	./python/ua_gec/stats.py all gec-only | tee stats.gec-only.txt

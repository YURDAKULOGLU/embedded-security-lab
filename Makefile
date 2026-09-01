.PHONY: doctor test demo proof audit

doctor:
	python3 scripts/doctor.py

test:
	python3 scripts/run_all.py

demo:
	python3 scripts/demo_full_lifecycle.py --clean

proof:
	python3 scripts/collect_evidence.py

audit:
	python3 scripts/repo_audit.py

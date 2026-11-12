# Changelog

## [0.1.0] - 2026-11-11

### Added

- Offline SmolVLM image descriptions and a free-form, scene-specific action ranked by Laya alongside four directions.
- Native CPU vision inference, grammar-constrained JSON, output validation and model checksum verification.
- Scene inspection, separate inference timings and model provenance in session history.
- Fork-specific Android identity and versioned APK builds, plus signed GitHub prerelease automation.
- Pipeline regression tests and a host JNI smoke-test fixture.

### Changed

- Pin kneejerk and llama.cpp as recursive repository dependencies instead of requiring a sibling checkout.
- Stop automatic captures when backgrounded, serialize model switching, and clear stale results on a new capture.

### Limitations

- Experimental suggestions and probabilities need human evaluation; no attached phone was available during development.
- GitHub release publication requires the four documented signing secrets.

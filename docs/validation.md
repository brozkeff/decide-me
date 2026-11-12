# Validation

## Automated checks

`npm test` checks that a generated activity outside the old vocabulary (for example,
“Enjoy your beer”) reaches Laya as the fifth choice, that uncertainty survives the
text boundary, and that invalid scenes or probability distributions are rejected.
This is a contract test, not evidence that SmolVLM recognizes beer reliably.

`npm run build` compiles the TypeScript bindings and application.
`tools/build-android.sh` additionally syncs Capacitor and builds the arm64 debug APK.

## Real-model host smoke test

Download the exact model revisions listed in `src/models.ts` and verify their SHA-256
checksums before testing. Keep weights outside Git. The host JNI fixture compiles
and calls the same C++ functions used by the Android bridge:

```bash
JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 \
MODEL_DIR=/tmp/decide-me-models \
tools/vision-smoke.sh docs/demo/g_bench_02.jpg docs/demo/g_busstop_04.jpg
```

This requires a host C++ compiler, CMake and the recursive submodules. Standard output
contains the generated JSON; model diagnostics and wall times go to standard error.
The fixture processes both frames through the same loaded context to detect stale-state
problems. Desktop timings are not Android benchmarks.

For Laya, build kneejerk's `systemone-cli` and send the JSON request produced by
`decisionRequest()` through stdin. Compare its stable choice keys with the app's expected
five keys. Quantized probabilities should also be compared with a llama-server built
from the same pinned source and weights before making numerical parity claims.

## Human and physical-device evaluation

Use an independently annotated set of photographs, including beer, coffee, ambiguous
drinks, seating, transit, entrances, darkness and scenes without an identifiable activity.
Review observations separately from activity suggestions. Multiple actions can be reasonable;
record acceptable activities and unsupported assumptions rather than one forced label.

For each model pipeline record observation accuracy, activity relevance, variation,
warm/cold median and p95 latency, peak process memory and failures. Run Laya on human
observations too, to isolate perception errors. Do not reuse d1 priors or assume its
calibration score measures novel actions. Verify first download, interrupted download,
airplane mode, backgrounding, model switches and a same-key APK upgrade on real hardware.

## Development observations (2026-11-12)

The pinned Laya Q8_0 was exercised through kneejerk's real CPU CLI with a human-written
beer scene and the application's generated request. It returned the five expected stable
choice IDs and selected `activity` with probability 0.8762 (four directions: 0.0364,
0.0307, 0.0298, 0.0268). This validates the interface on one example, not image recognition
or probability calibration. The run reported 8.67 seconds under concurrent compilation;
it is not a representative latency benchmark.

The two real photographs were also processed sequentially through the same host JNI
vision context, then their generated descriptions and activities were passed to Laya.
Both passed application validation; Laya returned all five expected probabilities and
ranked the proposed activity first in both examples. Raw results are in
[`vision_laya_smoke_2026-11-12.json`](../calibration/vision_laya_smoke_2026-11-12.json).
The bench suggestion was “looking out at the view”; the transit scene produced the awkward
“opened a ticket machine”. These examples establish a working pipeline, not improved
suggestion quality. The uncertainty field was also poorly used (“yes” on the transit image).
Vision took 30.07/38.23 seconds during concurrent compilation; these are desktop smoke-test
observations, not representative latency measurements.

The arm64 debug APK built successfully after enabling standalone mtmd and position-independent
static library code. Android tooling verified its v2 signature, fork package identity,
version suffix, bundled vision and decision JNI libraries, and packaged web assets.
No physical-device inference or signed-release upgrade was tested.

# decide me · brozkeff

An experimental Android app that looks at a photograph and suggests what to do next.
This fork adds **SmolVLM → Laya**: a small vision model describes visible facts and proposes
one activity in its own words, then Laya ranks that activity alongside Go left, Go right,
Go forward and Turn back. A beer can become “Enjoy your beer” without adding beer to a fixed action list.
Identification and suggestions can still be wrong.

The original d1 2B and d1-omni modes remain available for comparison. Their fixed actions
and calibration are described in [calibration](calibration/).

## Install and use

Install this fork's APK from [Releases](https://github.com/brozkeff/decide-me/releases),
allow the camera, select **SmolVLM → Laya**, and download its three model files (about 995 MB).
Subsequent inference works offline. Photos and descriptions stay on the phone.
Open **What it saw** to inspect observations, uncertainty, supporting evidence and stage timings.
History keeps the last twelve results for the current session.

Targets arm64 Android with 6–8 GB RAM. The fork uses application ID `net.brozkeff.decideme`
and can coexist with upstream. Percentages are model preferences, not measured probabilities
that a suggested activity is correct. This is a playful experiment, not a navigation aid.
No phone latency, memory or quality improvement is claimed without device measurements.

## Build locally

Requires Node 24, JDK 21, Android SDK platform/build-tools 36, NDK 27.2.12479018,
and CMake 3.22.1. Keep Java and SDK paths scoped to the build invocation:

```bash
git clone --recurse-submodules https://github.com/brozkeff/decide-me.git
cd decide-me
# For an existing checkout:
git submodule update --init --recursive
JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64 \
ANDROID_HOME="$HOME/Android/Sdk" \
tools/build-android.sh
```

The script installs the locked Node dependencies, tests, builds plugin bindings and the UI,
syncs Capacitor, and assembles `android/app/build/outputs/apk/debug/app-debug.apk`.
This APK is debug-signed. `APP_VERSION` defaults to `0.1.0-brozkeff.<short-sha>`;
`BUILD_NUMBER` defaults to 1 locally and can be overridden for upgrades.

## GitHub APK automation

Pull requests build a debug APK artifact. Pushes to the existing `main` branch (or `master`)
and manual workflow runs additionally build a signed release and publish an experimental
prerelease in this fork. Actions and the recursive native source are pinned.
Release versions, tags and asset names contain `brozkeff` and the source commit's short SHA.
The workflow uses an increasing Android version code.

Configure these repository Actions secrets with one stable release key:

- `ANDROID_KEYSTORE_BASE64`: base64-encoded Java keystore.
- `ANDROID_KEYSTORE_PASSWORD`: keystore password.
- `ANDROID_KEY_ALIAS`: signing alias.
- `ANDROID_KEY_PASSWORD`: key password.

Create and back up the key securely, for example using `keytool -genkeypair` interactively.
Keep it outside the repository. Missing secrets fail publication with an explicit error;
the debug artifact is still uploaded. Signed releases include the APK, SHA-256 checksum
and a build manifest containing the source and model revisions. Local debug builds and
release builds use different signing keys and cannot upgrade each other directly.

## Implementation and validation

The app-owned Capacitor vision bridge uses llama.cpp's mtmd image processing and a bounded,
grammar-constrained JSON generation pass. It returns observations, uncertainty, one proposed
activity and visual evidence. Laya receives only text, with stable choice IDs mapped to the UI.
Malformed output or missing evidence produces a retry error. The new model downloads use
pinned Hugging Face revisions and native streaming SHA-256 verification. Both models remain
loaded, inference is sequential, and Laya weight repacking is disabled to limit memory.

```bash
npm test
npm run build
```

The host JNI fixture in `tests/VisionSmoke.java` can exercise the exact vision implementation
with downloaded weights; see [validation notes](docs/validation.md). Pending physical-device
and human evaluation tasks are tracked in [PLANS.md](PLANS.md).

## Upstream and image credits

Forked from [moudrkat/decide-me](https://github.com/moudrkat/decide-me).
Native decisions use [kneejerk](https://github.com/moudrkat/kneejerk), with its pinned llama.cpp.
Vision weights: [SmolVLM GGUF](https://huggingface.co/ggml-org/SmolVLM-500M-Instruct-GGUF).
Decision weights: [Laya GGUF](https://huggingface.co/ggml-org/Laya-GGUF).
These new weight distributions are Apache-2.0; upstream source licenses remain in the submodules.

The app's screen in a desktop browser, with the answers d1 2B gave for these two photos through the
same library. Not a phone yet. Photos: Lairich Rig and M J Richardson, CC BY-SA 2.0, via Geograph and
Wikimedia Commons ([bench](https://commons.wikimedia.org/wiki/File:Bench_beside_path_-_geograph.org.uk_-_4114984.jpg),
[tram stop](https://commons.wikimedia.org/wiki/File:Princes_Street_tram_stop,_Edinburgh.jpg)).

I said I would not build this. I have discipline. 😇

(I built it the same morning. You don't need to decide that often in real life anyway.)

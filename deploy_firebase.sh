#!/usr/bin/env bash
#
# deploy_firebase.sh — Build a release APK and upload it to Firebase App
# Distribution for the "qa-testers" group.
#
# Requirements:
#   - Flutter SDK on PATH
#   - firebase-tools installed (npm install -g firebase-tools)
#   - Logged in: firebase login
#   - android/key.properties + release keystore (see android/RELEASE_SIGNING.md)
#
set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
# Firebase App ID (mobilesdk_app_id) from google-services.json.
# Firebase project: project1-787be (project_number 721124434634)
FIREBASE_APP_ID="1:721124434634:android:81bc1dbf296b99ce4d4a33"
FIREBASE_PROJECT_ID="project1-787be"

# Tester group alias to distribute the build to.
TESTER_GROUP="qa-testers"

# Release notes: latest git commit message (full body).
RELEASE_NOTES="$(git log -1 --pretty=%B)"

# Path to the APK produced by the build.
# We build with --split-per-abi (each APK ~28-34 MB instead of one 86 MB
# universal APK). The arm64-v8a APK covers virtually all modern physical
# devices and uploads far faster over slow links.
APK_PATH="build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"

# ---------------------------------------------------------------------------
# Sanity checks
# ---------------------------------------------------------------------------
if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: 'flutter' not found on PATH. Install the Flutter SDK." >&2
  exit 1
fi

if ! command -v firebase >/dev/null 2>&1; then
  echo "ERROR: 'firebase' (firebase-tools) not found. Install: npm install -g firebase-tools" >&2
  exit 1
fi

if ! firebase login:list 2>/dev/null | grep -qi "logged in"; then
  echo "ERROR: Not logged in to Firebase. Run: firebase login" >&2
  exit 1
fi

echo "==> Firebase App ID : ${FIREBASE_APP_ID}"
echo "==> Tester group    : ${TESTER_GROUP}"
echo "==> Release notes   : ${RELEASE_NOTES}"

# ---------------------------------------------------------------------------
# 1. Build the release APK
# ---------------------------------------------------------------------------
echo "==> Building release APKs (flutter build apk --release --split-per-abi)..."
flutter build apk --release --split-per-abi

if [[ ! -f "${APK_PATH}" ]]; then
  echo "ERROR: Expected APK not found at ${APK_PATH}" >&2
  exit 1
fi

echo "==> Built APK: ${APK_PATH} ($(du -h "${APK_PATH}" | cut -f1))"

# ---------------------------------------------------------------------------
# 2. Ensure the tester group exists (idempotent)
# ---------------------------------------------------------------------------
# App Distribution returns 404 when distributing to a group alias that does
# not exist yet. Create it if missing so the script is safe to re-run.
if ! firebase appdistribution:groups:list --project "${FIREBASE_PROJECT_ID}" 2>/dev/null | grep -q "${TESTER_GROUP}"; then
  echo "==> Creating tester group '${TESTER_GROUP}'..."
  firebase appdistribution:groups:create "QA Testers" "${TESTER_GROUP}" \
    --project "${FIREBASE_PROJECT_ID}"
else
  echo "==> Tester group '${TESTER_GROUP}' already exists."
fi

# ---------------------------------------------------------------------------
# 3. Upload to Firebase App Distribution (with retries — the link can be lossy)
# ---------------------------------------------------------------------------
upload_release() {
  firebase appdistribution:distribute "${APK_PATH}" \
    --app "${FIREBASE_APP_ID}" \
    --project "${FIREBASE_PROJECT_ID}" \
    --groups "${TESTER_GROUP}" \
    --release-notes "${RELEASE_NOTES}"
}

MAX_ATTEMPTS=3
for attempt in $(seq 1 "${MAX_ATTEMPTS}"); do
  echo "==> Uploading to Firebase App Distribution (attempt ${attempt}/${MAX_ATTEMPTS})..."
  if upload_release; then
    echo "==> Done. Release distributed to '${TESTER_GROUP}'."
    exit 0
  fi
  echo "!! Upload attempt ${attempt} failed." >&2
  [[ "${attempt}" -lt "${MAX_ATTEMPTS}" ]] && sleep 15
done

echo "ERROR: Upload failed after ${MAX_ATTEMPTS} attempts." >&2
exit 1
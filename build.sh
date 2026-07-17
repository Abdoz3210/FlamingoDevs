#!/usr/bin/env bash
set -euo pipefail

rm -rf .netlify/functions

flutter_dir="${HOME}/flutter"
flutter_revision="$(sed -n 's/^  revision: "\([^"]*\)"/\1/p' .metadata | head -n 1)"
release_manifest_url="https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json"

if [[ -z "${flutter_revision}" ]]; then
  echo "Unable to determine the Flutter revision from .metadata" >&2
  exit 1
fi

if [[ ! -x "${flutter_dir}/bin/flutter" ]] || [[ ! -f "${flutter_dir}/.netlify-revision" ]] || [[ "$(<"${flutter_dir}/.netlify-revision")" != "${flutter_revision}" ]]; then
  release_manifest="$(mktemp)"
  flutter_archive="$(mktemp --suffix=.tar.xz)"
  trap 'rm -f "${release_manifest}" "${flutter_archive}"' EXIT

  curl --fail --location --retry 3 --silent --show-error \
    "${release_manifest_url}" \
    --output "${release_manifest}"

  release_data="$(python3 - "${release_manifest}" "${flutter_revision}" <<'PY'
import json
import sys

manifest_path, revision = sys.argv[1:]

with open(manifest_path, encoding="utf-8") as manifest_file:
    manifest = json.load(manifest_file)

release = next(
    (item for item in manifest["releases"] if item["hash"] == revision),
    None,
)

if release is None:
    raise SystemExit(f"Flutter revision {revision} was not found in the Linux release manifest")

print("|".join((manifest["base_url"], release["archive"], release["sha256"])))
PY
)"

  IFS='|' read -r release_base_url archive_path archive_sha256 <<< "${release_data}"

  curl --fail --location --retry 3 --silent --show-error \
    "${release_base_url}/${archive_path}" \
    --output "${flutter_archive}"
  echo "${archive_sha256}  ${flutter_archive}" | sha256sum --check --status

  rm -rf "${flutter_dir}"
  tar --extract --xz --file "${flutter_archive}" --directory "${HOME}"
  printf '%s\n' "${flutter_revision}" > "${flutter_dir}/.netlify-revision"
fi

export PATH="${PATH}:${flutter_dir}/bin"

flutter precache --web
flutter build web --release

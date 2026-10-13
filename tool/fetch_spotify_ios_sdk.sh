#!/bin/sh
set -eu

pkg=$(find "$HOME/.pub-cache/hosted" -type d -name 'spotify_sdk_ios-*' | sort | tail -1)
if [ -z "$pkg" ]; then
  echo "spotify_sdk_ios is not in the pub cache. Run flutter pub get first." >&2
  exit 1
fi

dest="$pkg/ios/spotify_sdk_ios/ios-sdk/SpotifyiOS.xcframework"
binary="$dest/ios-arm64/SpotifyiOS.framework/SpotifyiOS"
if [ -f "$binary" ]; then
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL -o "$tmp/sdk.tar.gz" https://github.com/spotify/ios-sdk/archive/refs/tags/v5.0.1.tar.gz
tar -xzf "$tmp/sdk.tar.gz" -C "$tmp"
rm -rf "$dest"
mkdir -p "$(dirname "$dest")"
mv "$tmp/ios-sdk-5.0.1/SpotifyiOS.xcframework" "$dest"

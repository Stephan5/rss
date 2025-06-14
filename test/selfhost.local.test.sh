#!/bin/bash
set -Eeuo pipefail

cleanup() {
  aws s3 rm "s3://$BUCKET$BUCKET_PREFIX/$(basename "$TEST_DIR")/" --recursive || true
  rm -rf "$TEST_DIR"
}

# Given

# Create a temporary directory for test files
TEST_DIR=$(mktemp -d)

# Clean up on exit
trap cleanup EXIT

# Paths
SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../script" && pwd)/selfhost.sh"
INPUT="$TEST_DIR/feed.csv"
EXPECTED="$TEST_DIR/expected.csv"

# If AWS_ENDPOINT_URL is set, use a test bucket as we are in Github Actions
if [[ -n "${AWS_ENDPOINT_URL:-}" ]]; then
  BUCKET="test-bucket"
else
  BUCKET="test.blakeslee.uk"
fi

echo "Using bucket: $BUCKET"

TEST_MP3_FILE="file://resources/test.mp3"

# Create a sample CSV input
cat > "$INPUT" <<EOF
title;description;date;url
Episode 1;Desc 1;Jun 1, 2023;$TEST_MP3_FILE
Episode 2;Desc 2;Jul 2, 2023;$TEST_MP3_FILE
EOF

BUCKET_PREFIX="/rss"
S3_URL_1="https://s3.eu-west-2.amazonaws.com/$BUCKET$BUCKET_PREFIX/$(basename "$TEST_DIR")/1-episode-1.mp3"
S3_URL_2="https://s3.eu-west-2.amazonaws.com/$BUCKET$BUCKET_PREFIX/$(basename "$TEST_DIR")/2-episode-2.mp3"

cat > "$EXPECTED" <<EOF
title;description;date;url
Episode 1;Desc 1;Jun 1, 2023;$S3_URL_1
Episode 2;Desc 2;Jul 2, 2023;$S3_URL_2
EOF

# When
"$SCRIPT" "$INPUT" --delimiter ";" --bucket "$BUCKET" --prefix "$BUCKET_PREFIX"

# Then
if diff -u "$EXPECTED" <(cat "$INPUT"); then
  echo "✅ TEST PASS: Output matches expected."
else
  echo "❌ TEST FAIL: Output does not match expected."
  exit 1
fi
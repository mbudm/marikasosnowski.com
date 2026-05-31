#!/usr/bin/env bash
set -euo pipefail

BUCKET_NAME="${BUCKET_NAME:-marikasosnowskicom}"
DOMAIN="${DOMAIN:-marikasosnowski.com}"
PUBLIC_DIR="$(cd "$(dirname "$0")/../public" && pwd)"

echo "Syncing ${PUBLIC_DIR} to s3://${BUCKET_NAME}/"
aws s3 sync "${PUBLIC_DIR}" "s3://${BUCKET_NAME}/" \
  --delete \
  --exclude ".DS_Store"

if [[ -z "${CLOUDFRONT_DISTRIBUTION_ID:-}" ]]; then
  CLOUDFRONT_DISTRIBUTION_ID="$(
    aws cloudfront list-distributions \
      --query "DistributionList.Items[?contains(join(',', Aliases.Items || \`[]\`), '${DOMAIN}')].Id | [0]" \
      --output text
  )"
fi

if [[ -z "${CLOUDFRONT_DISTRIBUTION_ID}" || "${CLOUDFRONT_DISTRIBUTION_ID}" == "None" ]]; then
  echo "Could not find a CloudFront distribution for ${DOMAIN}."
  echo "Set CLOUDFRONT_DISTRIBUTION_ID and rerun, or invalidate the cache manually."
  exit 1
fi

echo "Invalidating CloudFront distribution ${CLOUDFRONT_DISTRIBUTION_ID}"
aws cloudfront create-invalidation \
  --distribution-id "${CLOUDFRONT_DISTRIBUTION_ID}" \
  --paths "/*"

echo "Deploy complete."

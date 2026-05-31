# marikasosnowski.com

Static site for Dr Marika Sosnowski. Source files live in `public/`.

## Local preview

```bash
npm install
npm run serve
```

Open http://localhost:5000

## Deploy

Infrastructure (S3, CloudFront, Route53) is already provisioned in AWS. To publish content changes, sync `public/` to the bucket and invalidate the CloudFront cache:

```bash
npm run deploy
```

Requires the [AWS CLI](https://aws.amazon.com/cli/) with credentials that can write to the bucket and create CloudFront invalidations.

Optional environment variables:

- `BUCKET_NAME` — defaults to `marikasosnowskicom`
- `DOMAIN` — defaults to `marikasosnowski.com` (used to look up the CloudFront distribution)
- `CLOUDFRONT_DISTRIBUTION_ID` — set this if auto-discovery fails

## Legacy `serverless.yml`

`serverless.yml` is kept for reference only. It describes the original stack definition (S3 website bucket, CloudFront distribution, Route53 record) but is no longer used for deploys — the Serverless plugins it relied on are outdated and a full redeploy is unnecessary for routine content updates.

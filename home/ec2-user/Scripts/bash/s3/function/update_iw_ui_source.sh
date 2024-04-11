#!/bin/bash
function update_iw_ui_source() {
    s3cmd put * s3://$1/ --recursive --cf-invalidate
    gzip -9 -k index.bundle.js 
    gzip -9 -k index.fonts.css
    gzip -9 -k index.styles.css
    aws s3api put-object --bucket $1 --key index.bundle.js --body index.bundle.js.gz  --content-type application/javascript --content-encoding gzip
    aws s3api put-object --bucket $1 --key index.fonts.css --body index.fonts.css.gz  --content-type text/css --content-encoding gzip
    aws s3api put-object --bucket $1 --key index.styles.css --body index.styles.css.gz  --content-type text/css --content-encoding gzip
}
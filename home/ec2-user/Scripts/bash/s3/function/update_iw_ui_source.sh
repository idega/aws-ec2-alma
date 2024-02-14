#!/bin/bash
function update_iw_ui_source() {
    s3cmd put * s3://$1/ --recursive
    aws s3api put-object --bucket $1 --key index.bundle.js --body index.bundle.js  --content-type application/javascript
    aws s3api put-object --bucket $1 --key index.fonts.css --body index.bundle.js  --content-type text/css
    aws s3api put-object --bucket $1 --key index.styles.css --body index.bundle.js  --content-type text/css
}
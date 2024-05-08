#!bin/bash
export IW_CA_DOMAIN=""
export IW_CA_DOMAIN_OWNER=""
export IW_CA_DOMAIN_REGION=""
export IW_CA_REPO_NAME=""
export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain $IW_CA_DOMAIN --domain-owner $IW_CA_DOMAIN_OWNER --query authorizationToken --output text --region $IW_CA_DOMAIN_REGION`

function iw_put_maven_artifact {
    local iw_maven_artifact_location="$1"
    local iw_maven_artifact_path=${iw_maven_artifact_location#*repository/}
    echo "Uploading: $iw_maven_artifact_path"

    curl --request PUT https://$IW_CA_DOMAIN-$IW_CA_DOMAIN_OWNER.d.codeartifact.$IW_CA_DOMAIN_REGION.amazonaws.com/maven/$IW_CA_REPO_NAME/$iw_maven_artifact_path \
        --user "aws:$CODEARTIFACT_AUTH_TOKEN" \
        --header "Content-Type: application/octet-stream" \
        --data-binary @$iw_maven_artifact_location
}

function iw_publish_maven_artifact {
    local iw_maven_artifact_location="${1%.*}"
    local iw_maven_artifact_file_name=${iw_maven_artifact_location##*/}
    local iw_maven_artifact_repo_path=${iw_maven_artifact_location#*repository/}
    iw_maven_artifact_repo_path=${iw_maven_artifact_repo_path%/*}
    local iw_maven_artifact_group_id=${iw_maven_artifact_repo_path%/*}
    iw_maven_artifact_group_id=${iw_maven_artifact_group_id%/*}
    iw_maven_artifact_group_id=${iw_maven_artifact_group_id//\//.}
    local iw_maven_artifact_id=${iw_maven_artifact_file_name%-*}
    local iw_maven_artifact_version=${iw_maven_artifact_file_name#*-}

    echo "Maven artifact path: $iw_maven_artifact_location"
    echo "Maven artifact filename: $iw_maven_artifact_file_name"
    echo "Maven artifact repo path: $iw_maven_artifact_repo_path"
    echo "Maven artifact group id: $iw_maven_artifact_group_id"
    echo "Maven artifact id: $iw_maven_artifact_id"
    echo "Maven artifact version: $iw_maven_artifact_version"

    iw_put_maven_artifact $iw_maven_artifact_location.pom
    iw_put_maven_artifact $iw_maven_artifact_location.jar

    aws codeartifact update-package-versions-status \
        --domain $IW_CA_DOMAIN \
        --domain-owner $IW_CA_DOMAIN_OWNER \
        --repository $IW_CA_REPO_NAME \
        --format maven \
        --namespace $iw_maven_artifact_group_id \
        --package $iw_maven_artifact_id \
        --versions $iw_maven_artifact_version \
        --target-status Published \
        --region $IW_CA_DOMAIN_REGION
}
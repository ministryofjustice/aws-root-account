# Based on: https://github.com/ministryofjustice/opg-org-infra/blob/main/scripts/redact_output.sh

sed -u -E \
    -e "s/AWS_SECRET_ACCESS_KEY=.*/AWS_SECRET_ACCESS_KEY=<REDACTED>/g" \
    -e "s/AWS_ACCESS_KEY_ID=.*/AWS_ACCESS_KEY_ID=<REDACTED>/g" \
    -e "s/\$(AWS_SECRET_ACCESS_KEY)=.*/\$(AWS_SECRET_ACCESS_KEY)=<REDACTED>/g" \
    -e "s/\$(AWS_ACCESS_KEY_ID)=.*/\$(AWS_ACCESS_KEY_ID)=<REDACTED>/g" \
    -e "s/\[id=[^]]*\]/\[id=<REDACTED>]/g" \
    -e "s/::[0-9]{12}:/::REDACTED:/g" \
    -e "s/:[0-9]{12}:/:REDACTED:/g" \
    -e "s/\"id\" = \"[0-9]{12}\"/\"id\" = \"<REDACTED>\"/g" \
    -e "s/\"email\" = \"[^\"]*\"/\"email\" = \"<REDACTED>\"/g" 
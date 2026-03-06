#!/bin/bash
set -e

# Script to update the root email address of AWS accounts

# CSV filename
csv_file="aws_mp_accounts.csv"

# Loop through each line in the CSV file and run aws account start-primary-email-update command and wait 5 seconds
while IFS=',' read -r account_id current_email new_email name otp; do
    # Skip the header line
    if [[ "$account_id" == "AccountID" ]]; then
        continue
    fi

    # Remove quotes from the fields
    account_id=$(echo "$account_id" | sed 's/^"//;s/"$//')
    current_email=$(echo "$current_email" | sed 's/^"//;s/"$//')
    new_email=$(echo "$new_email" | sed 's/^"//;s/"$//')
    name=$(echo "$name" | sed 's/^"//;s/"$//')
    otp=$(echo "$otp" | sed 's/^"//;s/"$//')

    # Print command to show which account email is being updated
    printf "Requesting email update for: $name\nNew email: $new_email\n--------------\n"

    # Run the command to update the email address
    aws account start-primary-email-update --account-id "$account_id" --primary-email "$new_email" --no-cli-pager

    # Wait for 5 seconds before the next iteration
    sleep 5
done < "$csv_file"
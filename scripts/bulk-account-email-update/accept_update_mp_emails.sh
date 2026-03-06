#!/bin/bash
set -e

# Script to accept the root email address change of mp accounts

# CSV filename
csv_file="aws_mp_accounts.csv"

# Loop through each line in the CSV file and run aws account accept-primary-email-update using the OTP and wait 5 seconds
while IFS=',' read -r account_id current_email new_email name otp; do
    # Skip the header line
    if [[ "$account_id" == "AccountID" ]]; then
        continue
    fi

   # Remove quotes and any whitespace from the fields
    account_id=$(echo "$account_id" | tr -d '"' | tr -d ' ')
    current_email=$(echo "$current_email" | tr -d '"' | tr -d ' ')
    new_email=$(echo "$new_email" | tr -d '"' | tr -d ' ')
    name=$(echo "$name" | tr -d '"' | tr -d ' ')
    otp=$(echo "$otp" | tr -d '"' | tr -d ' ' | tr -d '\r' | tr -d '\n')

    # Validate OTP format
    if ! [[ "$otp" =~ ^[A-Za-z0-9]{6}$ ]]; then
        echo "Error: Invalid OTP format for $name: '$otp'"
        continue
    fi

    # Run the command to accept the email address change
    echo "Accepting email update for $name with OTP: $otp"
    aws account accept-primary-email-update --account-id "$account_id" --otp "$otp" --primary-email "$new_email" --no-cli-pager

    # Wait for 5 seconds before the next iteration
    sleep 5
done < "$csv_file"
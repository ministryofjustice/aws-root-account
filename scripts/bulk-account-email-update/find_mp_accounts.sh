#!/bin/bash
set -e

# Script to find AWS accounts with "+mp" in root email and display in table format
# Shows both current email and new email without the "+mp" part
# Excludes suspended accounts and outputs results to Excel-compatible CSV file
# Requirements: AWS CLI, jq, and appropriate AWS permissions

# Check for required dependencies
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed or not in PATH"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed or not in PATH"
    exit 1
fi

# CSV filename
csv_file="aws_mp_accounts.csv"

# Create CSV header with special format for Excel
echo "AccountID,Current Email,New Email,Name,OTP" > "$csv_file"

# Store results in a temporary file to avoid subshell issues
temp_results=$(mktemp)

# List all accounts in the organization and save to temp file
# Filter for accounts that have "+mp" in email AND are not suspended
aws organizations list-accounts | \
jq -r '.Accounts[] | select(.Email | contains("+mp")) | select(.Status != "SUSPENDED") | 
    [.Id, .Email, .Name] | @tsv' > "$temp_results"

# Process results for display and CSV output
while IFS=$'\t' read -r account_id email name; do
    # Create the new email by removing "+mp" part
    # This handles both user+mp@domain.com and user+mp+something@domain.com formats
    new_email=$(echo "$email" | sed 's/\(.*\)\+mp\(.*\)@\(.*\)/\1\2@\3/')
    
    # Add to CSV with special format for the account ID to prevent Excel from converting it to scientific notation
    echo "\"$account_id\",\"$email\",\"$new_email\",\"$name\"" >> "$csv_file"
    
    # Increment counter
    ((count++))
done < "$temp_results"

# Sort the CSV file by the "Name" column (4th column) in ascending order
header=$(head -n 1 "$csv_file")
tail -n +2 "$csv_file" | sort -t, -k4,4 > "${csv_file}.sorted"
echo "$header" > "$csv_file"
cat "${csv_file}.sorted" >> "$csv_file"
rm "${csv_file}.sorted"

# Calculate total
total=$((count - 1))

# Clean up
rm "$temp_results"

echo "Search complete. Found $total active accounts with '+mp' in email."
echo "Results saved to $csv_file"
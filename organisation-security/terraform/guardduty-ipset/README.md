# GuardDuty IPSet Directory

This directory contains IP address lists used by AWS GuardDuty for threat detection customization.

## Files

- **github-actions-ranges.txt** (auto-generated): GitHub Actions IP ranges, automatically synced from the GitHub API on every Terraform run via `github-ipset-sync.tf`
- Additional `.txt` files can be placed here to add custom IP ranges to the IPSet

## How It Works

1. `github-ipset-sync.tf` fetches the current GitHub Actions IP ranges from https://api.github.com/meta
2. The `actions` array is extracted and written to `github-actions-ranges.txt`
3. `guardduty-ipset.tf` aggregates all `.txt` files in this directory
4. The combined list is used to configure GuardDuty IPSet across all AWS regions

## Adding Custom IP Ranges

Create additional `.txt` files in this directory, one IP/CIDR per line:

```
# custom-ips.txt
192.0.2.0/24
198.51.100.0/24
```

The next Terraform run will automatically include these in the IPSet.

## Security Notes

- The IPSet bucket is private and encrypted
- Only GuardDuty service-linked role can read the objects
- All changes are tracked via Terraform state

## Last Updated

IP ranges are automatically synced on every `terraform apply`/`terraform plan` run.

# Automatically fetch GitHub Actions IP addresses from the GitHub API
# and make them available to GuardDuty IPSet configuration
#
# This data source runs on every terraform run, ensuring the IPSet
# always contains the current list of GitHub Actions IP ranges.

# Fetch GitHub's meta API to get current IP address ranges
data "http" "github_meta" {
  url = "https://api.github.com/meta"

  request_headers = {
    Accept = "application/vnd.github+json"
  }

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "GitHub meta API returned status ${self.status_code}. Please check the API endpoint."
    }
  }
}

# Extract and transform the GitHub Actions IPs into the IPSet format
locals {
  github_actions_ips  = try(data.http.github_meta.response_body != "" ? jsondecode(data.http.github_meta.response_body)["actions"] : [], [])
  github_actions_text = join("\n", local.github_actions_ips)
}

# Automatically write GitHub Actions IPs to a file that gets included in the IPSet
resource "local_file" "github_actions_ipset" {
  filename = "${path.module}/guardduty-ipset/github-actions-ranges.txt"
  content  = local.github_actions_text
}

# Optional: Output the fetched IPs for debugging
output "github_actions_ip_count" {
  description = "Number of GitHub Actions IP ranges fetched"
  value       = length(local.github_actions_ips)
}

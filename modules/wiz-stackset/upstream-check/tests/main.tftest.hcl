mock_provider "http" {
  override_data {
    target = data.http.wiz_upstream
    values = {
      response_body = "{\"Parameters\":{\"WizVersionLastUpdated\":{\"Default\":\"2026-10-21\"}}}"
    }
  }
}

variables {
  url               = "https://example.invalid/wiz-aws-standard.json"
  committed_sha256  = "78bcd37d0463436165e3e62e63bd9322a2b2e04bc93b158bc399eec88f9a71b2" # sha256 of the mocked response_body
  committed_version = "2026-10-21"
}

run "matches_committed" {
  command = plan
}

run "warn_when_upstream_differs" {
  command = plan

  override_data {
    target = data.http.wiz_upstream
    values = {
      response_body = "{\"Parameters\":{\"WizVersionLastUpdated\":{\"Default\":\"2099-01-01\"}}}"
    }
  }

  expect_failures = [check.wiz_template_current]
}

run "warn_when_upstream_unreadable" {
  command = plan

  override_data {
    target = data.http.wiz_upstream
    values = {
      response_body = "<Error>AccessDenied</Error>"
    }
  }

  expect_failures = [check.wiz_template_current]
}

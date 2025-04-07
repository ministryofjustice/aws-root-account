
## Scripts to bulk update root account emails

The scripts in this folder can be used to update the aws account root account emails in bulk. This was used as part of issue [#9527](https://github.com/ministryofjustice/modernisation-platform/issues/9527) where we needed to remove the additional `+mp` tag in our emails which would not have been compatible with o365.

##### Notes

- This was performed as an ad-hoc local operation. We do not expect to repeat this process but we are leaving the code here just in case it's useful in future.

- As the name suggests the `gmail-reader.py` script will only work for gmail. In future we will be migrating to o365. A similar Microsoft API might be able to be utilised but this would require a major update to this script.

- All the other scripts are also focused on targetting emails with `+mp` in them but this regex could be easily updated as needed.

## Pre-requisites

1. To do this you will need `Administrator Access` to the `moj-master` account so that you have the relevant credentials/permissions to perform `account:accept-primary-email-update` and `account:start-primary-email-update`.

2. You will need to be granted access to the `aws@digital.justice.gov.uk` gmail group so that the emails are sent to your inbox.

3. You'll need to set up credentials to allow Google to access your inbox as follows:


    ##### Step 1: Enable Gmail API for Your Personal Account

    - Go to the Google Cloud Console.
    - Click Select a project (top bar) → New Project.
    - Name the project (e.g., Gmail API Access) → Click Create.
    - In the left menu, go to APIs & Services > Library.
    - Search for "Gmail API" → Click Enable.

    ##### Step 2: Create OAuth Credentials for Your Personal Inbox
    - Go to APIs & Services > Credentials.
    - Click Create Credentials → Select OAuth Client ID.
    - If prompted, configure the OAuth Consent Screen:
    - Choose External (even in a Workspace environment).
    - Fill in App Name (e.g., "Gmail OTP Extractor").
    - Use your email for the User Support Email and Developer Contact Info.
    - Click Save & Continue.
    - Under Scopes, click "Add or Remove Scopes", then add: `https://www.googleapis.com/auth/gmail.readonly`
    - Click Save & Continue.
    - Under Test Users, add your own email.
    - Click Save & Continue → Click Back to Dashboard.

    ##### Step 3: Download credentials.json
    - Go to APIs & Services > Credentials.
    - Under "OAuth 2.0 Client IDs", find your Desktop App.
    - Click Download JSON and save it as credentials.json in your script directory.

## Usage guide

1. First run `./find_mp_accounts.sh` - this will produce a csv with all matching accounts called `aws_mp_accounts.csv`
2. Run `./request_update_mp_emails.sh`- this will start the process and multiple emails will be sent to `aws@digital.justice.gov.uk` with an OTP for each account.
    - You will need admin credentials for `moj-master` `Administrator Access` set in your env
3. Run the `gmail-reader.py` script - this will update `aws_mp_accounts.csv` with the OTPs
    - You will need to have a suitable python environment set up and have the dependencies installed in `requirements.txt`
4. Run the `./accept_update_mp_accounts.sh` - this will confirm the account email change and multiple emails will be sent to `aws@digital.justice.gov.uk`to confirm
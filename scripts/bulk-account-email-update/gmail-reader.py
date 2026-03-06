import base64
from bs4 import BeautifulSoup
import csv
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
import re

# Define Gmail API scope
SCOPES = ["https://www.googleapis.com/auth/gmail.readonly"]

def authenticate_gmail():
    """Authenticate and return the Gmail API service"""
    flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
    creds = flow.run_local_server(port=0)
    return build("gmail", "v1", credentials=creds)

def extract_body(payload):
    """Recursively extract the plain text or HTML body from the email payload."""
    if "parts" in payload:
        for part in payload["parts"]:
            if part.get("mimeType") == "text/plain":
                body_data = part.get("body", {}).get("data", "")
                return base64.urlsafe_b64decode(body_data).decode("utf-8")
            elif part.get("mimeType") == "text/html":
                body_data = part.get("body", {}).get("data", "")
                html_content = base64.urlsafe_b64decode(body_data).decode("utf-8")
                # Parse HTML and extract text
                soup = BeautifulSoup(html_content, "html.parser")
                return soup.get_text()
            elif "parts" in part:
                # Recursively check nested parts
                result = extract_body(part)
                if result:
                    return result
    return ""

def update_otp(file_path, email, otp):
    """Update the OTP column in the CSV file for the given email."""
    rows = []
    updated = False
    with open(file_path, mode='r', newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        fieldnames = reader.fieldnames
        for row in reader:
            if row['Current Email'] == email or row['New Email'] == email:
                row['OTP'] = otp  # Update the OTP column
                updated = True
            rows.append(row)

    with open(file_path, mode='w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    if updated:
        print(f"CSV updated for Email: {email}, OTP: {otp}")
    else:
        print(f"Email not found in CSV: {email}")

def get_otp_from_emails(service, csv_file_path):
    """Fetch OTPs and recipient email addresses from AWS verification emails and update the CSV file."""
    query = 'subject:"Verify the new email address for the AWS account root user"'
    
    # Initialize variables for pagination
    next_page_token = None
    all_messages = []
    
    # Fetch all messages using pagination
    while True:
        results = service.users().messages().list(
            userId="me",
            q=query,
            pageToken=next_page_token,
            maxResults=500  # Increase max results per page
        ).execute()
        
        if 'messages' in results:
            all_messages.extend(results['messages'])
        
        # Check if there are more pages
        next_page_token = results.get('nextPageToken')
        if not next_page_token:
            break
    
    print(f"Found {len(all_messages)} messages.")

    for msg in all_messages:
        msg_id = msg["id"]
        msg_data = service.users().messages().get(userId="me", id=msg_id, format="full").execute()
        payload = msg_data.get("payload", {})

        # Extract email body
        body = extract_body(payload)

        # Normalize the email body
        normalized_body = body.replace("\r\n", " ").strip()
        normalized_body = re.sub(r"\s+", " ", normalized_body)  # Collapse multiple spaces into one

        # Extract recipient email address from the body
        email_match = re.search(r"to use your email address \(([^)]+)\)", normalized_body)
        recipient_email = email_match.group(1) if email_match else None

        # Extract OTP from email body
        otp_match = re.search(r"please use the following code to verify your email address:\s*(\d{6})\.", normalized_body)
        otp = otp_match.group(1) if otp_match else None

        if recipient_email and otp:
            print(f"Processing Email: {recipient_email}, OTP: {otp}")
            update_otp(csv_file_path, recipient_email, otp)  # Update the CSV file
        else:
            print(f"Failed to extract OTP or email from message ID: {msg_id}")

if __name__ == "__main__":
    # Authenticate with Gmail API
    gmail_service = authenticate_gmail()

    # Path to the CSV file
    csv_file_path = './aws_mp_accounts.csv'

    # Fetch OTPs and update the CSV file
    get_otp_from_emails(gmail_service, csv_file_path)

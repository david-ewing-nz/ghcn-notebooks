#!/usr/bin/env python3
"""
Automated Notification System for Diagnostic Results
Sends notifications when diagnostic results are detected
"""

import subprocess
import sys
from datetime import datetime


def send_notification(version, results_file):
    """Send notification about found diagnostic results"""

    # Load the results
    try:
        with open(results_file, "r") as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading results file: {e}")
        return

    # Create notification message
    subject = f"GHCN Diagnostic Results Found - {version} Version"
    message = f"""
Automated Notification: Diagnostic Results Detected

Version: {version}
Timestamp: {datetime.now().isoformat()}
Results File: {results_file}

Summary of Results:
{content[:500]}... (see full file for details)

The automated system has detected and extracted diagnostic
results from the {version} Build notebook.
Results have been saved and the analysis is complete.

Next Steps:
1. Review the results in: results/{version}_analysis_summary.txt
2. Compare with GOOD notebook baseline if needed
3. The system will continue monitoring for new results
"""

    print(f"[{datetime.now()}] Sending notification for {version} results...")

    # Option 1: Windows Toast Notification (built-in)
    try:
        toast_cmd = (
            f'New-BurntToastNotification -Text "{subject}", ' f'"{message[:200]}..."'
        )
        subprocess.run(["powershell", "-command", toast_cmd], capture_output=True)
        print(f"[{datetime.now()}] Windows toast notification sent!")
    except Exception as e:
        print(f"Toast notification failed: {e}")

    # Option 2: Log to file (always works)
    with open("notification_log.txt", "a") as f:
        f.write(f"\n[{datetime.now()}] NOTIFICATION: {subject}\n")
        f.write(f"Message: {message}\n")
        f.write("=" * 50 + "\n")

    print(f"[{datetime.now()}] Notification logged to notification_log.txt")

    # Option 3: Email notification (uncomment and configure if needed)
    """
    try:
        # Configure your email settings here
        smtp_server = "smtp.gmail.com"
        smtp_port = 587
        sender_email = "your-email@gmail.com"
        sender_password = "your-app-password"
        receiver_email = "your-email@gmail.com"

        msg = MIMEText(message)
        msg['Subject'] = subject
        msg['From'] = sender_email
        msg['To'] = receiver_email

        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, receiver_email, msg.as_string())
        server.quit()

        print(f"[{datetime.now()}] Email notification sent!")
    except Exception as e:
        print(f"Email notification failed: {e}")
    """


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python send_notification.py <version> <results_file>")
        sys.exit(1)

    version = sys.argv[1]
    results_file = sys.argv[2]

    send_notification(version, results_file)

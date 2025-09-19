import os
import sys
import winsound

from win10toast import ToastNotifier


def alert_user(message, title="ACTION REQUIRED"):
    # Windows toast notification
    try:
        toaster = ToastNotifier()
        toaster.show_toast(title, message, duration=10, threaded=True)
    except Exception as e:
        print(f"Toast notification failed: {e}")
    # Console alert
    print(f"\n{'='*40}\n{title}: {message}\n{'='*40}\n")
    # Audible beep
    for _ in range(2):
        winsound.Beep(1000, 400)


if __name__ == "__main__":
    alert_user(
        "Your approval is required for a new automation feature or major change."
    )

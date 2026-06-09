# ALU Connect

A mobile app that helps African Leadership University students discover, join, and engage with campus opportunities — all in one place instead of scattered across WhatsApp groups, emails, and Slack channels.

---

## Features

- **Opportunity Feed** — browse all campus events with search and category filters
- **Event Details** — see full info: title, description, date, location, organizer, and category
- **RSVP** — join or leave an event with one tap
- **Bookmarks** — save events to revisit later
- **Live Chat** — private chat room for everyone who joined an event
- **Public Comments** — ask questions and reply on any event (visible to all)
- **Organizer Tools** — create events and see the full participant list
- **Role-based Experience** — Students and Organizers see a different interface
- **Persistent Data** — joined events, bookmarks, messages, and comments survive app restarts

---

## App Walkthrough

**Students**
1. Register with your name, email, and select **Student**
2. Browse the feed — search by name or tap a category chip to filter
3. Tap any event to see its details
4. Hit **RSVP Now** to join — the event appears in your **My Events** tab
5. Tap **Live Chat** to talk with other attendees
6. Scroll down on the event page to read and add public comments
7. Tap the bookmark icon to save an event for later

**Organizers**
1. Register and select **Organizer**
2. Use the **Create Event** tab to publish a new opportunity
3. Open your event to see the list of students who signed up
4. Access the Live Chat and Comments on your event just like a student

---

## Getting Started

**Requirements**
- Flutter SDK (use [FVM](https://fvm.app) if managing multiple Flutter versions)
- Dart SDK `^3.12.0`
- Android Studio or Xcode for a device/emulator

**Steps**

```bash
# 1. Clone the repo
git clone <repo-url>
cd alu-connect

# 2. Install dependencies
fvm flutter pub get

# 3. Run the app
fvm flutter run
```

**Demo accounts** (pre-loaded, no setup needed)

| Role | Email | Password |
|------|-------|----------|
| Student | student@alu.com | password123 |
| Organizer | organizer@alu.com | password123 |

Or create your own account from the Register screen.

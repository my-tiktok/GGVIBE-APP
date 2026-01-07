# GGVIBE

A Flutter Web PWA (Progressive Web App) for realtime 1:1 chat built with clean architecture.

## Features

- 🔐 **Email Authentication** - Login and signup with Firebase Auth
- 💬 **Realtime Chat** - 1:1 messaging with Cloud Firestore
- 📱 **Telegram-style UI** - Clean inbox interface for conversations
- 🏗️ **Clean Architecture** - Scalable folder structure with separation of concerns
- 🌐 **PWA Support** - Installable web app with offline capabilities
- 🔥 **Firebase Backend** - Firebase Auth, Cloud Firestore, and Firebase Storage

## Tech Stack

- **Frontend**: Flutter 3
- **State Management**: BLoC (flutter_bloc)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Architecture**: Clean Architecture (Domain, Data, Presentation layers)

## Project Structure

```
lib/
├── core/                          # Core functionality
│   ├── error/                     # Error handling
│   ├── usecases/                  # Base use case classes
│   └── utils/                     # Utilities (DI, etc.)
├── features/
│   ├── auth/                      # Authentication feature
│   │   ├── data/                  # Data layer
│   │   │   ├── datasources/       # Remote data sources
│   │   │   ├── models/            # Data models
│   │   │   └── repositories/      # Repository implementations
│   │   ├── domain/                # Domain layer
│   │   │   ├── entities/          # Business entities
│   │   │   ├── repositories/      # Repository contracts
│   │   │   └── usecases/          # Business logic
│   │   └── presentation/          # Presentation layer
│   │       ├── bloc/              # BLoC state management
│   │       ├── pages/             # UI screens
│   │       └── widgets/           # UI components
│   └── chat/                      # Chat feature
│       ├── data/                  # Data layer
│       ├── domain/                # Domain layer
│       └── presentation/          # Presentation layer
└── main.dart                      # App entry point
```

## Setup Instructions

### Prerequisites

- Flutter 3.x installed
- Firebase project created
- Node.js (for Firebase CLI)

### Firebase Configuration

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable **Email/Password** authentication
3. Create a **Cloud Firestore** database
4. Create a **Firebase Storage** bucket
5. Register your web app and get the Firebase config

### Configuration

Update the Firebase configuration in `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    authDomain: 'YOUR_AUTH_DOMAIN',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    appId: 'YOUR_APP_ID',
  ),
);
```

### Installation

```bash
# Get dependencies
flutter pub get

# Run on Chrome (web)
flutter run -d chrome

# Build for production
flutter build web
```

## Firestore Database Structure

### Collections

#### `conversations`
```
{
  "id": "conversation_id",
  "participantIds": ["user1_id", "user2_id"],
  "lastMessage": "Hello!",
  "lastMessageTime": Timestamp
}
```

#### `messages`
```
{
  "id": "message_id",
  "conversationId": "conversation_id",
  "senderId": "user_id",
  "text": "Message content",
  "timestamp": Timestamp
}
```

## Security Rules

Ensure you configure appropriate Firestore security rules in the Firebase Console.

## Development

### Running Tests

```bash
flutter test
```

### Code Analysis

```bash
flutter analyze
```

## PWA Features

- Installable on desktop and mobile devices
- Offline support with service workers
- App-like experience with manifest.json
- Responsive design for all screen sizes

## License

MIT License - see LICENSE file for details

## Notes

- Replace Firebase configuration placeholders with your actual Firebase project credentials
- This is a production-ready scaffold without demo/mock data
- No secrets or credentials are included in the codebase

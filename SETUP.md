# GGVIBE Setup Guide

This guide will help you set up and run the GGVIBE Flutter Web PWA.

## Prerequisites

1. **Flutter SDK** (3.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **Firebase Project**
   - Create at: https://console.firebase.google.com/

## Step-by-Step Setup

### 1. Firebase Project Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name (e.g., "ggvibe")
4. Follow the wizard to create the project

### 2. Enable Firebase Services

#### Enable Authentication
1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Go to **Sign-in method** tab
4. Enable **Email/Password** provider
5. Click **Save**

#### Create Firestore Database
1. In Firebase Console, go to **Firestore Database**
2. Click **Create database**
3. Choose **Start in test mode** (you can configure security rules later)
4. Select a location closest to your users
5. Click **Enable**

#### Enable Storage
1. In Firebase Console, go to **Storage**
2. Click **Get started**
3. Choose **Start in test mode**
4. Click **Done**

### 3. Register Web App

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll down to **Your apps**
3. Click the web icon `</>`
4. Register app with nickname "GGVIBE Web"
5. Copy the Firebase configuration object

### 4. Configure the App

1. Open `lib/main.dart`
2. Replace the Firebase configuration with your values:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY_HERE',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    messagingSenderId: 'YOUR_SENDER_ID',
    appId: 'YOUR_APP_ID',
  ),
);
```

### 5. Install Dependencies

```bash
cd /path/to/GGVIBE-APP
flutter pub get
```

### 6. Run the App

#### Development Mode
```bash
# Run on Chrome
flutter run -d chrome

# Or run on web server
flutter run -d web-server --web-port=8080
```

#### Production Build
```bash
# Build optimized web app
flutter build web

# Deploy the build/web folder to your hosting service
```

### 7. Configure Firestore Security Rules (Production)

In Firebase Console, go to **Firestore Database > Rules** and update:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow authenticated users to read/write their conversations
    match /conversations/{conversationId} {
      allow read: if request.auth != null && 
                  request.auth.uid in resource.data.participantIds;
      allow create: if request.auth != null;
      allow update: if request.auth != null && 
                    request.auth.uid in resource.data.participantIds;
    }
    
    // Allow authenticated users to read/write messages in their conversations
    match /messages/{messageId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
                    request.auth.uid == request.resource.data.senderId;
    }
  }
}
```

### 8. Deploy to Firebase Hosting (Optional)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project
firebase init hosting

# Build the app
flutter build web

# Deploy
firebase deploy --only hosting
```

## Testing the App

1. **Create Account**: Use the signup page to create a test account
2. **Login**: Login with your test credentials
3. **Chat**: Create conversations and send messages

## Troubleshooting

### Issue: Firebase not initialized
- Verify Firebase configuration in `lib/main.dart`
- Check that all Firebase services are enabled in console

### Issue: Build errors
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Issue: Web app not loading
- Clear browser cache
- Check browser console for errors
- Verify Firebase configuration

## Production Checklist

- [ ] Replace Firebase config with production values
- [ ] Configure Firestore security rules
- [ ] Configure Storage security rules
- [ ] Enable Firebase App Check
- [ ] Set up proper authentication flow
- [ ] Add error tracking (e.g., Sentry)
- [ ] Configure proper CORS settings
- [ ] Test on multiple browsers
- [ ] Test PWA installation
- [ ] Optimize bundle size

## Support

For issues or questions, please refer to:
- Flutter Documentation: https://flutter.dev/docs
- Firebase Documentation: https://firebase.google.com/docs

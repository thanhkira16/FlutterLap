# Chat UI Clone

A Flutter project that implements a chat user interface similar to popular messaging apps like WhatsApp or Messenger.

## 📱 Features

- Clean and modern chat interface
- Dynamic message bubbles with different styles for sender and receiver
- Scrollable message list with ListView
- Text input field with send button
- Real-time message updates
- Sample conversation demo

## 🛠 Technical Implementation

### Key Components

- `ListView` for scrollable message display
- `Row` and `Column` for layout structuring
- `Container` for styling message bubbles
- Custom widgets for reusability

### Project Structure

```
lib/
  ├── models/          # Data models
  │   └── message.dart # Message model class
  ├── screens/         # App screens
  │   └── chat_screen.dart # Main chat interface
  └── widgets/         # Reusable components
      └── message_bubble.dart # Message bubble widget
```

## 🚀 Getting Started

1. Make sure you have Flutter installed on your machine
2. Clone this repository
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 💡 Possible Enhancements

- Add user avatars
- Display message timestamps
- Implement emoji support
- Add file/image sharing capabilities
- Add chat themes and customization options
- Implement message reactions
- Add typing indicators

## 🔧 Requirements

- Flutter SDK
- Dart SDK
- Any IDE with Flutter support (VS Code, Android Studio, etc.)

## 📝 License

This project is open source and available under the MIT License.

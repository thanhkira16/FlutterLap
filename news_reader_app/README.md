# News Reader App

A Flutter-based mobile application for reading news articles from various sources.

## Features

- Browse latest news articles
- Filter news by categories
- Search for specific news topics
- Bookmark favorite articles
- Clean and intuitive user interface
- Dark/Light theme support

## Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android SDK / iOS SDK for mobile development

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/news_reader_app.git
```

2. Navigate to project directory:
```bash
cd news_reader_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── models/         # Data models
├── screens/        # UI screens
├── services/       # API and backend services
├── widgets/        # Reusable widgets
└── main.dart       # Entry point
```

## Dependencies

- http: ^1.1.0
- provider: ^6.0.5
- shared_preferences: ^2.2.0
- cached_network_image: ^3.3.0

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- [News API](https://newsapi.org/) for providing news data

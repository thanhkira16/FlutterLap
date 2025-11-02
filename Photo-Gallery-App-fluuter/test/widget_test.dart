import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photo_gallery_app/main.dart';

void main() {
  testWidgets('Photo Gallery smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PhotoGalleryApp());

    // Verify app launched successfully
    expect(find.byType(Scaffold), findsWidgets);
  });
}

import 'dart:io';
import 'package:decibel/features/upload/domain/entities/track_upload_metadata.dart';
import 'package:decibel/features/upload/presentation/widgets/track_info_checklist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Helper to build the widget quickly
  Widget buildChecklist(TrackUploadMetadata metadata) {
    return MaterialApp(
      home: Scaffold(body: TrackInfoChecklist(metadata: metadata)),
    );
  }

  testWidgets('displays 0/4 completed when metadata is empty', (tester) async {
    // 1. Arrange: Completely empty metadata
    const emptyMetadata = TrackUploadMetadata();

    await tester.pumpWidget(buildChecklist(emptyMetadata));

    // 2. Assert
    expect(find.text('0/4', findRichText: true), findsOneWidget);
  });

  testWidgets('displays 2/4 completed when title and genre are present', (
    tester,
  ) async {
    // 1. Arrange: 2 out of 4 fields filled
    const partialMetadata = TrackUploadMetadata(
      title: 'My Track',
      genre: 'Rock',
    );

    await tester.pumpWidget(buildChecklist(partialMetadata));

    // 2. Assert
    expect(find.text('2/4', findRichText: true), findsOneWidget);
  });

  testWidgets('displays 4/4 completed when all fields are present', (
    tester,
  ) async {
    // 1. Arrange: All 4 fields filled (Title, Artwork, Genre, Description)
    final fullMetadata = TrackUploadMetadata(
      title: 'My Track',
      genre: 'Rock',
      description: 'A great rock song',
      coverImage: File('dummy_image.png'),
    );

    await tester.pumpWidget(buildChecklist(fullMetadata));

    // 2. Assert
    expect(find.text('4/4', findRichText: true), findsOneWidget);
  });

  testWidgets('tapping the checklist opens the detailed bottom sheet', (
    tester,
  ) async {
    // 1. Arrange
    const emptyMetadata = TrackUploadMetadata();
    await tester.pumpWidget(buildChecklist(emptyMetadata));

    // 2. Act: Tap the container
    await tester.tap(find.text('Track info checklist'));
    await tester.pumpAndSettle(); // Wait for bottom sheet animation

    // 3. Assert: Check if the bottom sheet header text is visible
    expect(find.text('Get everything in place'), findsOneWidget);
    expect(find.text('Track title'), findsOneWidget);
    expect(find.text('Artwork'), findsOneWidget);
  });
}

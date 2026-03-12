import 'package:decibel/features/library/domain/repositories/track_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(environment: 'mock');
  runApp(const ProviderScope(child: DecibelApp()));
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency injection
  await configureDependencies(environment: 'mock'); // Use mock for testing

  runApp(const ProviderScope(child: DecibelApp()));
}

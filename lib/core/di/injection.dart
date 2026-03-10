/// GetIt + Injectable service locator setup.
library;

import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/// Call this before runApp() to register all dependencies.
Future<void> configureDependencies() async {}

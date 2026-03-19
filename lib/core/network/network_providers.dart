import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../di/injection.dart'; 
import 'dio_client.dart';


/// This provider bridges your Injectable Singleton into the Riverpod world.
final apiClientProvider = Provider<DioClient>((Ref ref) {
  return getIt<DioClient>(); 
});
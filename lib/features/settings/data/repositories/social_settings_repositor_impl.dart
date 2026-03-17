import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/shared_prefs_service.dart';
import '../../domain/repositories/social_settings_repository.dart';

/// Provider to access the concrete implementation
final socialSettingsRepositoryProvider = Provider<SocialSettingsRepository>((ref) {
  final prefsService = ref.watch(sharedPrefsServiceProvider);
  return SocialSettingsRepositoryImpl(prefsService);
});

class SocialSettingsRepositoryImpl implements SocialSettingsRepository {

  SocialSettingsRepositoryImpl(this._prefs);
  final SharedPrefsService _prefs;

  static const String _waveformKey = 'show_waveform';
  static const String _activitiesKey = 'show_activities';
  static const String _topFanKey = 'show_top_fan';

  @override
  Future<Map<String, bool>> getSettings() async {
    final waveform = await _prefs.getString(_waveformKey);
    final activities = await _prefs.getString(_activitiesKey);
    final topFan = await _prefs.getString(_topFanKey);

    return {
      'waveform': waveform == 'true', 
      'activities': activities == 'true',
      'top_fan': topFan == 'true',
    };
  }

  @override
  Future<void> updateSetting(String key, bool value) async {
    final prefKey = {
      'waveform': _waveformKey,
      'activities': _activitiesKey,
      'top_fan': _topFanKey,
    }[key];

    if (prefKey != null) {
      await _prefs.setString(prefKey, value.toString());
    }
  }
}
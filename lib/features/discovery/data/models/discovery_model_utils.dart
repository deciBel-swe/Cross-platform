Map<String, dynamic> asMapOrEmpty(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return <String, dynamic>{};
}

List<Map<String, dynamic>> asMapList(Object? value) {
  if (value is! List) {
    return const <Map<String, dynamic>>[];
  }

  return value
      .map(asMapOrEmpty)
      .where((Map<String, dynamic> item) => item.isNotEmpty)
      .toList(growable: false);
}

Object? unwrapDataEnvelope(Object? value) {
  final map = asMapOrEmpty(value);
  if (map.isEmpty) {
    return value;
  }

  final nested = map['data'];
  return nested ?? value;
}

int? asInt(Object? value) {
  return switch (value) {
    int raw => raw,
    num raw => raw.toInt(),
    String raw => int.tryParse(raw),
    _ => null,
  };
}

String? asString(Object? value) {
  return switch (value) {
    String raw when raw.trim().isNotEmpty => raw.trim(),
    num raw => raw.toString(),
    _ => null,
  };
}

bool asBool(Object? value, {bool fallback = false}) {
  return switch (value) {
    bool raw => raw,
    String raw => raw.toLowerCase() == 'true',
    num raw => raw != 0,
    _ => fallback,
  };
}

DateTime? asDateTime(Object? value) {
  final raw = asString(value);
  if (raw == null) {
    return null;
  }

  return DateTime.tryParse(raw);
}

List<String> asStringList(Object? value) {
  if (value is! List) {
    return const <String>[];
  }

  return value
      .map(asString)
      .whereType<String>()
      .toList(growable: false);
}

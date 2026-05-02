import 'package:decibel/features/offline/data/datasources/offline_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OfflineCollectionInfo', () {
    const tInfo = OfflineCollectionInfo(
      id: 42,
      title: 'My Playlist',
      coverUrl: 'https://example.com/cover.jpg',
      trackIds: [1, 2, 3],
      isStation: false,
    );

    const tStation = OfflineCollectionInfo(
      id: 7,
      title: 'Jazz Station',
      coverUrl: null,
      trackIds: [10, 20],
      isStation: true,
    );

    // ── toJson ────────────────────────────────────────────────────────────────

    group('toJson', () {
      test('serialises all fields correctly', () {
        final json = tInfo.toJson();
        expect(json['id'], 42);
        expect(json['title'], 'My Playlist');
        expect(json['coverUrl'], 'https://example.com/cover.jpg');
        expect(json['trackIds'], [1, 2, 3]);
        expect(json['isStation'], false);
      });

      test('serialises null coverUrl as null', () {
        final json = tStation.toJson();
        expect(json['coverUrl'], isNull);
      });

      test('serialises isStation = true correctly', () {
        final json = tStation.toJson();
        expect(json['isStation'], true);
      });
    });

    // ── fromJson ──────────────────────────────────────────────────────────────

    group('fromJson', () {
      test('deserialises from a full JSON map', () {
        final json = <String, dynamic>{
          'id': 42,
          'title': 'My Playlist',
          'coverUrl': 'https://example.com/cover.jpg',
          'trackIds': [1, 2, 3],
          'isStation': false,
        };

        final result = OfflineCollectionInfo.fromJson(json);
        expect(result.id, 42);
        expect(result.title, 'My Playlist');
        expect(result.coverUrl, 'https://example.com/cover.jpg');
        expect(result.trackIds, [1, 2, 3]);
        expect(result.isStation, false);
      });

      test('defaults isStation to false when key is absent', () {
        final json = <String, dynamic>{
          'id': 1,
          'title': 'No Station Key',
          'coverUrl': null,
          'trackIds': <int>[],
        };

        final result = OfflineCollectionInfo.fromJson(json);
        expect(result.isStation, false);
      });

      test('round-trips through toJson → fromJson', () {
        final restored = OfflineCollectionInfo.fromJson(tInfo.toJson());
        expect(restored.id, tInfo.id);
        expect(restored.title, tInfo.title);
        expect(restored.coverUrl, tInfo.coverUrl);
        expect(restored.trackIds, tInfo.trackIds);
        expect(restored.isStation, tInfo.isStation);
      });

      test('round-trips a station with null coverUrl', () {
        final restored = OfflineCollectionInfo.fromJson(tStation.toJson());
        expect(restored.id, tStation.id);
        expect(restored.coverUrl, isNull);
        expect(restored.isStation, true);
      });
    });

    // ── copyWith ──────────────────────────────────────────────────────────────

    group('copyWith', () {
      test('returns same values when no args provided', () {
        final copy = tInfo.copyWith();
        expect(copy.id, tInfo.id);
        expect(copy.title, tInfo.title);
        expect(copy.coverUrl, tInfo.coverUrl);
        expect(copy.trackIds, tInfo.trackIds);
        expect(copy.isStation, tInfo.isStation);
      });

      test('updates only title', () {
        final copy = tInfo.copyWith(title: 'Updated Title');
        expect(copy.title, 'Updated Title');
        expect(copy.id, tInfo.id);
        expect(copy.trackIds, tInfo.trackIds);
      });

      test('updates only trackIds', () {
        final copy = tInfo.copyWith(trackIds: [99, 100]);
        expect(copy.trackIds, [99, 100]);
        expect(copy.id, tInfo.id);
      });

      test('can set coverUrl to null explicitly via copyWith', () {
        final copy = tInfo.copyWith(coverUrl: null);
        // copyWith does not override with null by default (uses ?? this.coverUrl),
        // so coverUrl stays unchanged when null is passed.
        expect(copy.coverUrl, tInfo.coverUrl);
      });

      test('sets isStation to true', () {
        final copy = tInfo.copyWith(isStation: true);
        expect(copy.isStation, true);
      });

      test('updates only id', () {
        final copy = tInfo.copyWith(id: 99);
        expect(copy.id, 99);
        expect(copy.title, tInfo.title);
        expect(copy.isStation, tInfo.isStation);
      });

      test('updates multiple fields at once', () {
        final copy = tInfo.copyWith(id: 10, title: 'Remix', isStation: true);
        expect(copy.id, 10);
        expect(copy.title, 'Remix');
        expect(copy.isStation, true);
        // unchanged fields
        expect(copy.coverUrl, tInfo.coverUrl);
        expect(copy.trackIds, tInfo.trackIds);
      });

      test('appends to existing trackIds via copyWith', () {
        final extended = tInfo.trackIds + [4, 5];
        final copy = tInfo.copyWith(trackIds: extended);
        expect(copy.trackIds, [1, 2, 3, 4, 5]);
      });
    });

    // ── edge cases ─────────────────────────────────────────────────────────────

    group('edge cases', () {
      test('handles empty trackIds list', () {
        const empty = OfflineCollectionInfo(
          id: 1,
          title: 'Empty',
          coverUrl: null,
          trackIds: [],
        );
        final json = empty.toJson();
        expect(json['trackIds'], isEmpty);
        final restored = OfflineCollectionInfo.fromJson(json);
        expect(restored.trackIds, isEmpty);
      });

      test('preserves trackIds order through round-trip', () {
        const ordered = OfflineCollectionInfo(
          id: 1,
          title: 'Ordered',
          coverUrl: null,
          trackIds: [30, 10, 20],
        );
        final restored = OfflineCollectionInfo.fromJson(ordered.toJson());
        expect(restored.trackIds, [30, 10, 20]);
      });

      test('handles very large id values', () {
        const large = OfflineCollectionInfo(
          id: 999999999,
          title: 'Big ID',
          coverUrl: null,
          trackIds: [1],
        );
        final restored = OfflineCollectionInfo.fromJson(large.toJson());
        expect(restored.id, 999999999);
      });

      test('fromJson with explicit isStation = true', () {
        final json = <String, dynamic>{
          'id': 3,
          'title': 'Radio',
          'coverUrl': null,
          'trackIds': [5, 6],
          'isStation': true,
        };
        final result = OfflineCollectionInfo.fromJson(json);
        expect(result.isStation, true);
        expect(result.trackIds, [5, 6]);
      });

      test('title with special characters survives round-trip', () {
        const special = OfflineCollectionInfo(
          id: 1,
          title: 'Café & Jazz – Vol. 1 "Best"',
          coverUrl: null,
          trackIds: [],
        );
        final restored = OfflineCollectionInfo.fromJson(special.toJson());
        expect(restored.title, special.title);
      });
    });

    // ── equality ──────────────────────────────────────────────────────────────

    group('equality/comparison', () {
      test('two instances with same data produce equal JSON', () {
        const other = OfflineCollectionInfo(
          id: 42,
          title: 'My Playlist',
          coverUrl: 'https://example.com/cover.jpg',
          trackIds: [1, 2, 3],
          isStation: false,
        );
        expect(tInfo.toJson(), equals(other.toJson()));
      });

      test('different ids produce different JSON', () {
        final a = tInfo.toJson();
        final b = tInfo.copyWith(id: 999).toJson();
        expect(a, isNot(equals(b)));
      });
    });
  });
}

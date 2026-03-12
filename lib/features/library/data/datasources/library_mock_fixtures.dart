class LibraryMockFixtures {
  LibraryMockFixtures._();

  static const Duration mockDelay = Duration(milliseconds: 800);

  /// Mock response for GET /api/users/{userId}/tracks
  static const Map<String, dynamic> mockTracksResponse = {
    "content": [
      {
        "id": 1,
        "title": "Chill Night Beat",
        "artist": {"id": 10, "username": "karim"},
        "trackUrl": "http://example.com/audio1.mp3",
        "coverUrl": "http://example.com/cover1.jpg",
        "waveformUrl": null,
        "genre": "Lo-fi",
        "tags": ["chill", "night"],
        "state": "FINISHED",
        "releaseDate": "2024-01-01",
        "playCount": 120,
        "likeCount": 18,
        "repostCount": 4,
        "createdAt": "2024-01-01T10:00:00.000Z",
      },
      {
        "id": 2,
        "title": "Processing Track",
        "artist": {"id": 11, "username": "tarek"},
        "trackUrl": "http://example.com/audio2.mp3",
        "coverUrl": "http://example.com/cover2.jpg",
        "waveformUrl": null,
        "genre": "House",
        "tags": ["draft"],
        "state": "PROCESSING",
        "releaseDate": "2024-01-02",
        "playCount": 0,
        "likeCount": 0,
        "repostCount": 0,
        "createdAt": "2024-01-02T10:00:00.000Z",
      },
    ],
    "pageNumber": 0,
    "pageSize": 10,
    "totalElements": 2,
    "totalPages": 1,
    "isLast": true,
  };

  /// Mock responses for GET /tracks/{trackId}
  static const Map<int, Map<String, dynamic>> trackMetaDataById = {
    1: {
      "id": 1,
      "title": "Chill Night Beat",
      "artist": {"id": 10, "username": "karim"},
      "trackUrl": "http://example.com/audio1.mp3",
      "coverUrl": "http://example.com/cover1.jpg",
      "waveformUrl": null,
      "genre": "Lo-fi",
      "tags": ["chill", "night"],
      "state": "FINISHED",
      "releaseDate": "2024-01-01",
      "playCount": 120,
      "likeCount": 18,
      "repostCount": 4,
      "createdAt": "2024-01-01T10:00:00.000Z",
    },
    2: {
      "id": 2,
      "title": "Processing Track",
      "artist": {"id": 11, "username": "tarek"},
      "trackUrl": "http://example.com/audio2.mp3",
      "coverUrl": "http://example.com/cover2.jpg",
      "waveformUrl": null,
      "genre": "House",
      "tags": ["draft"],
      "state": "PROCESSING",
      "releaseDate": "2024-01-02",
      "playCount": 0,
      "likeCount": 0,
      "repostCount": 0,
      "createdAt": "2024-01-02T10:00:00.000Z",
    },
  };

  /// Mock responses for GET /tracks/{trackId}/peaks
  static const Map<int, Map<String, dynamic>> trackPeaksById = {
    1: {
      "trackId": 1,
      "duration": 185,
      "peaks": [
        8,
        14,
        20,
        32,
        40,
        28,
        22,
        18,
        35,
        50,
        42,
        30,
        24,
        16,
        12,
        26,
        38,
        46,
        34,
        20,
      ],
    },
    2: {
      "trackId": 2,
      "duration": 210,
      "peaks": [
        4,
        8,
        12,
        16,
        12,
        8,
        6,
        4,
        10,
        14,
        18,
        12,
        8,
        6,
        4,
        8,
        10,
        12,
        8,
        6,
      ],
    },
  };

  static Object? getTrackPeaksById(int id) {}
}

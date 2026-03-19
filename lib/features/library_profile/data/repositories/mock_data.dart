import 'dart:convert';

import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';

class MockUserRepository {
  
  Future<UserProfile> fetchMockUserProfile() async {
    // Simulate a 1-second network delay
    await Future.delayed(const Duration(seconds: 1));

    // Your exact JSON string
    const String mockApiResponse = '''
    {
    "id": 10485,
    "Role": "ARTIST",
    "email": "alex.synth@example.com",
    "username": "alex_synth",
    "emailVerified": true,
    "tier": "PRO",
    "profile": {
        "bio": "Electronic music producer & sound designer. Late night beats.",
        "city": "Berlin",
        "country": "Germany",
        "profilePic": "https://i.pravatar.cc/150?u=alex_synth",
        "coverPic": "https://images.unsplash.com/photo-1518609878373-06d740f60d8b",
        "favoriteGenres": [
            "Synthwave",
            "Techno",
            "Cyberpunk"
        ]
    },
    "socialLinks": {
        "instagram": "https://instagram.com/alex_synth",
        "website": "https://alexsynthmusic.com",
        "supportLink": "https://patreon.com/alex_synth",
        "twitter": "https://twitter.com/alex_synth"
    },
    "privacySettings": {
        "isPrivate": false,
        "showHistory": true
    },
    "stats": {
        "followers": 12450,
        "following": 312,
        "tracksCount": 24
    }
}
    ''';

    // 1. Decode and CAST to Map<String, dynamic> to fix the type error
    final Map<String, dynamic> decodedJson = jsonDecode(mockApiResponse) as Map<String, dynamic>;

    // 2. Pass the map directly to the Freezed model (no 'data' wrapper to worry about)
    final userModel = UserProfileModel.fromJson(decodedJson);
    
    // 3. Convert to your Entity and return
    return userModel.toEntity();
  }
}
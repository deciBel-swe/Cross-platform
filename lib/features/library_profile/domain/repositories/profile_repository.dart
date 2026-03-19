import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/public_profile_social_links.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, bool>> updateProfile({
    String? bio,
    String? city,
    String? country,
    List<String>? favoriteGenres,
  });
  Future<Either<Failure, PublicProfileSocialLinks>> updateSocialLinks(
    PublicProfileSocialLinks links,
  );
}

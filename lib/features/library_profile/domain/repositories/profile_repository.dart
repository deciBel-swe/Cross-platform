import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';
import '../entities/public_profile_social_links.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> updateSocialLinks(
    PublicProfileSocialLinks links,
  );
}

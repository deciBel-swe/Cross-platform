import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/public_profile_social_links.dart';

abstract class ProfileRepository {
  Future<Either<Failure, PublicProfileSocialLinks>> updateSocialLinks(
    PublicProfileSocialLinks links,
  );
}

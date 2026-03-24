import 'dart:io';

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
    PublicProfileSocialLinks? socialLinks,
  });
  Future<Either<Failure, PublicProfileSocialLinks>> updateSocialLinks(
    PublicProfileSocialLinks links,
  );
  Future<Either<Failure, bool>> updateImages({
    File? profilePic,
    File? coverPic,
  });
}

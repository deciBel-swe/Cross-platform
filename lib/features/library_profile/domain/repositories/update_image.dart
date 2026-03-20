import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileImagesUseCase {
  final ProfileRepository repository;

  UpdateProfileImagesUseCase(this.repository);

  Future<Either<Failure, bool>> execute({File? profilePic, File? coverPic}) {
    return repository.updateImages(profilePic: profilePic, coverPic: coverPic);
  }
}
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class UpdateProfileImagesUseCase {
  UpdateProfileImagesUseCase(this.repository);
  final ProfileRepository repository;

  Future<Either<Failure, bool>> execute({File? profilePic, File? coverPic}) {
    return repository.updateImages(profilePic: profilePic, coverPic: coverPic);
  }
}
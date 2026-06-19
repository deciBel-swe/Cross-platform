import 'package:injectable/injectable.dart';

import '../../domain/repositories/change_email_repository.dart';
import '../datasources/change_email_remote_datasource.dart';

@LazySingleton(as: ChangeEmailRepository)
class ChangeEmailRepositoryImpl implements ChangeEmailRepository {
  ChangeEmailRepositoryImpl(this._remoteDatasource);

  final ChangeEmailRemoteDatasource _remoteDatasource;

  @override
  Future<String> changeEmail({required String newEmail}) {
    return _remoteDatasource.changeEmail(newEmail: newEmail);
  }
}

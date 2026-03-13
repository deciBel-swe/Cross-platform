// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/library/data/repositories/image_repository_impl.dart'
    as _i989;
import '../../features/library/domain/repositories/image_repository.dart'
    as _i925;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i183.ImagePicker>(() => appModule.imagePicker);
    gh.factory<_i925.ImageRepository>(
      () => _i989.ImageRepositoryImpl(gh<_i183.ImagePicker>()),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}

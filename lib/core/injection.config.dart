// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:itodev_task/feature_2/data/datasources/accelermeter_local_data_source.dart'
    as _i927;
import 'package:itodev_task/feature_2/data/respositories/accelerometer_repository_impl.dart'
    as _i651;
import 'package:itodev_task/feature_2/domain/repositories/accelerometr_repository.dart'
    as _i855;
import 'package:itodev_task/feature_2/domain/usecases/load_accelererometer_data_use_case.dart'
    as _i607;
import 'package:itodev_task/feature_2/domain/usecases/save_accelerometer_data_use_case.dart'
    as _i419;
import 'package:itodev_task/feature_2/presentation/cubit/accelometer_cubit.dart'
    as _i316;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i927.AccelerometerLocalDataSource>(
      () => _i927.AccelerometerLocalDataSource(),
    );
    gh.singleton<_i855.AccelerometerRepository>(
      () => _i651.AccelerometerRepositoryImpl(
        gh<_i927.AccelerometerLocalDataSource>(),
      ),
    );
    gh.factory<_i419.SaveAccelerometerData>(
      () => _i419.SaveAccelerometerData(gh<_i855.AccelerometerRepository>()),
    );
    gh.factory<_i607.LoadAccelerometerData>(
      () => _i607.LoadAccelerometerData(gh<_i855.AccelerometerRepository>()),
    );
    gh.factory<_i316.AccelerometerCubit>(
      () => _i316.AccelerometerCubit(
        gh<_i419.SaveAccelerometerData>(),
        gh<_i607.LoadAccelerometerData>(),
      ),
    );
    return this;
  }
}

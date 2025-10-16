import 'package:injectable/injectable.dart';
import 'package:itodev_task/feature_2/data/datasources/accelermeter_local_data_source.dart';
import 'package:itodev_task/feature_2/domain/entites/accelerometer_data.dart';
import 'package:itodev_task/feature_2/domain/repositories/accelerometr_repository.dart';

@Singleton(as: AccelerometerRepository)
class AccelerometerRepositoryImpl implements AccelerometerRepository {
  final AccelerometerLocalDataSource localDataSource;

  AccelerometerRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveData(AccelerometerData data) async {
    await localDataSource.saveToFile({'x': data.x, 'y': data.y, 'z': data.z});
  }

  @override
  Future<AccelerometerData?> loadData() async {
    final json = await localDataSource.readFromFile();
    if (json == null) return null;

    return AccelerometerData(
      x: List<double>.from(json['x']),
      y: List<double>.from(json['y']),
      z: List<double>.from(json['z']),
    );
  }
}

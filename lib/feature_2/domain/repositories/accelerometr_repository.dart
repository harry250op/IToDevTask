import 'package:itodev_task/feature_2/domain/entites/accelerometer_data.dart';

abstract class AccelerometerRepository {
  Future<void> saveData(AccelerometerData data);
  Future<AccelerometerData?> loadData();
}

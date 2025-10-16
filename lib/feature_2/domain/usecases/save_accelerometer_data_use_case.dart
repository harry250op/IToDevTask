import 'package:injectable/injectable.dart';
import 'package:itodev_task/feature_2/domain/entites/accelerometer_data.dart';
import 'package:itodev_task/feature_2/domain/repositories/accelerometr_repository.dart';

@injectable
class SaveAccelerometerData {
  final AccelerometerRepository repository;

  SaveAccelerometerData(this.repository);

  Future<void> call(AccelerometerData data) async {
    await repository.saveData(data);
  }
}

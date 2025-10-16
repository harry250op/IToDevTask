import 'package:injectable/injectable.dart';
import 'package:itodev_task/feature_2/domain/entites/accelerometer_data.dart';
import 'package:itodev_task/feature_2/domain/repositories/accelerometr_repository.dart';

@injectable
class LoadAccelerometerData {
  final AccelerometerRepository repository;

  LoadAccelerometerData(this.repository);

  Future<AccelerometerData?> call() async => await repository.loadData();
}

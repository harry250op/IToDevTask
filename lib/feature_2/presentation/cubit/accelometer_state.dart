part of 'accelometer_cubit.dart';

@freezed
class AccelerometerState with _$AccelerometerState {
  const factory AccelerometerState.initial() = _Initial;
  const factory AccelerometerState.data(
    List<double> x,
    List<double> y,
    List<double> z,
    DurationEnum duration,
    bool isPaused,
  ) = _Data;
  const factory AccelerometerState.error(String message) = _Error;
  const factory AccelerometerState.success(String message) = _Success;
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:itodev_task/core/bloc_extension.dart';
import 'package:itodev_task/feature_2/domain/entites/accelerometer_data.dart';
import 'package:itodev_task/feature_2/domain/usecases/load_accelererometer_data_use_case.dart';
import 'package:itodev_task/feature_2/domain/usecases/save_accelerometer_data_use_case.dart';
import 'package:itodev_task/feature_2/presentation/model/duration_enum.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:rxdart/rxdart.dart';

part 'accelometer_state.dart';
part 'accelometer_cubit.freezed.dart';

@injectable
class AccelerometerCubit extends Cubit<AccelerometerState>
    with WidgetsBindingObserver {
  AccelerometerCubit(this.saveAccelerometerData, this.loadAccelerometerData)
    : super(AccelerometerState.initial());
  final SaveAccelerometerData saveAccelerometerData;
  final LoadAccelerometerData loadAccelerometerData;

  late final Stream<AccelerometerEvent> _accelerometerStream;
  StreamSubscription<AccelerometerEvent>? _subscription;

  Future<void> initAccelerometer() async {
    const DurationEnum defaultDuration = DurationEnum.one;
    _accelerometerStream = accelerometerEventStream().throttleTime(
      defaultDuration.duration,
    );
    _subscription = _accelerometerStream.listen(
      (AccelerometerEvent event) async {
        _handleAccelerometerEvent(event, defaultDuration);
      },
      onError: (error) {
        safeEmit(AccelerometerState.error(error.toString()));
      },
    );
  }

  void pause() {
    if (state is! _Data) {
      return;
    } else if ((state as _Data).isPaused) {
      if (_subscription == null) {
        initAccelerometer();
      } else {
        _subscription?.resume();
      }
    } else {
      _subscription?.pause();
    }
    safeEmit((state as _Data).copyWith(isPaused: !(state as _Data).isPaused));
  }

  void setDuration(DurationEnum duration) {
    if (_subscription == null) {
      initAccelerometer();
      return;
    }
    _subscription = _accelerometerStream
        .throttleTime(duration.duration)
        .listen(
          (AccelerometerEvent event) async {
            _handleAccelerometerEvent(event, duration);
          },
          onError: (error) {
            safeEmit(AccelerometerState.error(error.toString()));
          },
        );
    _subscription?.resume();
  }

  Future<void> _handleAccelerometerEvent(
    AccelerometerEvent event,
    DurationEnum defaultDuration,
  ) async {
    final List<double> x = List.from(
      state.maybeWhen(data: (x, _, __, ___, ____) => x, orElse: () => []),
    );
    final List<double> y = List.from(
      state.maybeWhen(data: (_, y, __, ___, ____) => y, orElse: () => []),
    );
    final List<double> z = List.from(
      state.maybeWhen(data: (_, __, z, ___, ____) => z, orElse: () => []),
    );
    x.add(event.x);
    y.add(event.y);
    z.add(event.z);
    safeEmit(AccelerometerState.data(x, y, z, defaultDuration, false));
    await Future.delayed(defaultDuration.duration);
  }

  Future<void> saveData() async {
    if (state is! _Data) return;
    final currentState = state as _Data;
    await saveAccelerometerData.call(
      AccelerometerData(
        x: currentState.x,
        y: currentState.y,
        z: currentState.z,
      ),
    );
    safeEmit(
      const AccelerometerState.success('The data was saved successfully'),
    );
    safeEmit(currentState);
  }

  Future<void> loadData() async {
    final data = await loadAccelerometerData.call();
    if (data == null) {
      safeEmit(const AccelerometerState.error('No saved data found'));
      safeEmit(const AccelerometerState.initial());
      return;
    }
    safeEmit(AccelerometerState.success('The data was loaded successfully'));
    safeEmit(
      AccelerometerState.data(data.x, data.y, data.z, DurationEnum.one, true),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if ([
      AppLifecycleState.paused,
      AppLifecycleState.inactive,
      AppLifecycleState.detached,
    ].contains(state)) {
      pause();
      super.didChangeAppLifecycleState(state);
    }
  }

  void dispose() {
    _subscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    close();
  }
}

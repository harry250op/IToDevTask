import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodev_task/core/injection.dart';
import 'package:itodev_task/feature_2/presentation/cubit/accelometer_cubit.dart';
import 'package:itodev_task/feature_2/presentation/model/duration_enum.dart';
import 'package:itodev_task/feature_2/presentation/widget/graph_widget.dart';

class AccelerometerPage extends StatelessWidget {
  const AccelerometerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AccelerometerCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Accelerometer Page'),
          automaticallyImplyLeading: true,
        ),
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  static const TextStyle textStyle = TextStyle(fontSize: 20);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccelerometerCubit, AccelerometerState>(
      builder: (context, state) {
        return Center(
          child: state.maybeWhen(
            initial: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      context.read<AccelerometerCubit>().initAccelerometer(),
                  child: Text('Start', style: textStyle),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      context.read<AccelerometerCubit>().loadData(),
                  child: Text('Load saved data', style: textStyle),
                ),
              ],
            ),
            data: (x, y, z, duration, isPaused) => Column(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SegmentedButton<DurationEnum>(
                  multiSelectionEnabled: false,
                  segments: DurationEnum.values
                      .map(
                        (e) => ButtonSegment<DurationEnum>(
                          value: e,
                          label: Text(e.name),
                        ),
                      )
                      .toList(),
                  selected: {duration},
                  onSelectionChanged: !isPaused
                      ? null
                      : (newSelection) {
                          context.read<AccelerometerCubit>().setDuration(
                            newSelection.first,
                          );
                        },
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      spacing: 4,
                      children: [
                        _accelerometerText(
                          'X: ${x.last.toStringAsFixed(2)}',
                          Colors.red,
                        ),

                        _accelerometerText(
                          'Y: ${y.last.toStringAsFixed(2)}',
                          Colors.green,
                        ),
                        _accelerometerText(
                          'Z: ${z.last.toStringAsFixed(2)}',
                          Colors.blue,
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<AccelerometerCubit>().pause(),
                      child: Text(
                        isPaused ? 'Resume' : 'Pause',
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(height: 300, child: GraphWidget()),
                ElevatedButton(
                  onPressed: isPaused
                      ? () => context.read<AccelerometerCubit>().saveData()
                      : null,
                  child: Text('Save data', style: textStyle),
                ),
              ],
            ),
            orElse: () => SizedBox.shrink(),
          ),
        );
      },
      listener: (BuildContext context, AccelerometerState state) =>
          state.maybeWhen(
            error: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $message')));
              return null;
            },
            success: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Success: $message')));
              return null;
            },
            orElse: () {
              return null;
            },
          ),
    );
  }

  Widget _accelerometerText(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    margin: const EdgeInsets.symmetric(vertical: 2),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(text, style: textStyle),
  );
}

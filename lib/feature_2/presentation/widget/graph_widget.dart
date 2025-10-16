import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itodev_task/feature_2/presentation/cubit/accelometer_cubit.dart';

class GraphWidget extends StatefulWidget {
  const GraphWidget({super.key});

  @override
  State<GraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<GraphWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 300,
    child: BlocBuilder<AccelerometerCubit, AccelerometerState>(
      builder: (context, state) {
        return state.maybeWhen(
          data: (x, y, z, _, isPaused) => SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: x.length * 25.0 + 100,

              child: BarChart(
                BarChartData(
                  maxY: 10,
                  minY: -10,
                  barGroups: List.generate(x.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: x[index],
                          color: Colors.red,
                          width: 4,
                        ),
                        BarChartRodData(
                          toY: y[index],
                          color: Colors.green,
                          width: 4,
                        ),
                        BarChartRodData(
                          toY: z[index],
                          color: Colors.blue,
                          width: 4,
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(),

                    topTitles: AxisTitles(),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
              ),
            ),
          ),
          orElse: () => const SizedBox(),
        );
      },
    ),
  );
}

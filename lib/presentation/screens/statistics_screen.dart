import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../data/models/daily_log.dart';
import '../../domain/bloc/daily_log/daily_log_bloc.dart';
import '../../domain/bloc/daily_log/daily_log_event.dart';
import '../../domain/bloc/daily_log/daily_log_state.dart';
import '../../domain/bloc/settings/settings_bloc.dart';
import '../../domain/bloc/settings/settings_event.dart';
import '../../domain/bloc/settings/settings_state.dart';
import '../widgets/calorie_limit_dialog.dart';

/// Screen for displaying statistics and setting calorie limits
class StatisticsScreen extends StatefulWidget {
  /// Constructs a StatisticsScreen
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final DateFormat _dateFormat = DateFormat('MMM d');

  @override
  void initState() {
    super.initState();
    context.read<DailyLogBloc>().add(const LoadAllDailyLogs());
    context.read<SettingsBloc>().add(const LoadSettings());
  }

  void _showCalorieLimitDialog() {
    final settingsState = context.read<SettingsBloc>().state;
    int initialLimit = 2000;

    if (settingsState is SettingsLoaded) {
      initialLimit = settingsState.settings.dailyCalorieLimit;
    }

    // Сохраняем ссылки на блоки перед асинхронной операцией
    final settingsBloc = context.read<SettingsBloc>();
    final dailyLogBloc = context.read<DailyLogBloc>();

    showDialog(
      context: context,
      builder: (context) => CalorieLimitDialog(initialLimit: initialLimit),
    ).then((newLimit) {
      if (newLimit != null && newLimit is int) {
        settingsBloc.add(UpdateCalorieLimit(newLimit));

        final today = DateTime.now();
        dailyLogBloc.add(UpdateDailyCalorieLimit(today, newLimit));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showCalorieLimitDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Daily calorie limit card
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is SettingsLoaded) {
                return Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Calorie Limit',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Row(
                          children: [
                            Text(
                              '${state.settings.dailyCalorieLimit}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: _showCalorieLimitDialog,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is SettingsLoading) {
                return const Card(
                  margin: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),

          // Chart
          BlocBuilder<DailyLogBloc, DailyLogState>(
            builder: (context, state) {
              if (state is AllDailyLogsLoaded) {
                final dailyLogs = state.dailyLogs;

                if (dailyLogs.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text('No data available yet.'),
                    ),
                  );
                }

                // Sort logs by date
                dailyLogs.sort((a, b) => a.date.compareTo(b.date));

                // Take only the last 7 days
                final recentLogs = dailyLogs.length > 7
                    ? dailyLogs.sublist(dailyLogs.length - 7)
                    : dailyLogs;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last ${recentLogs.length} Days',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16.0),
                        Expanded(
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: _getMaxY(recentLogs),
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipBgColor: Colors.blueGrey,
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                    final log = recentLogs[groupIndex];
                                    return BarTooltipItem(
                                      '${log.caloriesConsumed} / ${log.calorieLimit}',
                                      const TextStyle(color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      if (value.toInt() >= 0 &&
                                          value.toInt() < recentLogs.length) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            _dateFormat.format(
                                                recentLogs[value.toInt()].date),
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: _createBarGroups(recentLogs),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is DailyLogLoading) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return const Expanded(
                  child: Center(child: Text('No data available.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  double _getMaxY(List<DailyLog> logs) {
    double maxY = 0;
    for (final log in logs) {
      final max = log.calorieLimit > log.caloriesConsumed
          ? log.calorieLimit.toDouble()
          : log.caloriesConsumed.toDouble();
      if (max > maxY) {
        maxY = max;
      }
    }
    return maxY * 1.2; // Add some padding
  }

  List<BarChartGroupData> _createBarGroups(List<DailyLog> logs) {
    return List.generate(logs.length, (index) {
      final log = logs[index];
      final consumed = log.caloriesConsumed.toDouble();
      final limit = log.calorieLimit.toDouble();

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: consumed,
            color: consumed > limit ? Colors.red : Colors.blue,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }
}

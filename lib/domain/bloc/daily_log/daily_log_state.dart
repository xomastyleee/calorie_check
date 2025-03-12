import 'package:equatable/equatable.dart';

import '../../../data/models/daily_log.dart';

/// States for the daily log bloc
abstract class DailyLogState extends Equatable {
  const DailyLogState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the daily log bloc
class DailyLogInitial extends DailyLogState {
  const DailyLogInitial();
}

/// State when daily logs are being loaded
class DailyLogLoading extends DailyLogState {
  const DailyLogLoading();
}

/// State when a single daily log has been loaded successfully
class DailyLogLoaded extends DailyLogState {
  /// The daily log
  final DailyLog dailyLog;

  const DailyLogLoaded(this.dailyLog);

  @override
  List<Object?> get props => [dailyLog];
}

/// State when all daily logs have been loaded successfully
class AllDailyLogsLoaded extends DailyLogState {
  /// The list of daily logs
  final List<DailyLog> dailyLogs;

  const AllDailyLogsLoaded(this.dailyLogs);

  @override
  List<Object?> get props => [dailyLogs];
}

/// State when there's an error loading daily logs
class DailyLogError extends DailyLogState {
  /// The error message
  final String message;

  const DailyLogError(this.message);

  @override
  List<Object?> get props => [message];
}

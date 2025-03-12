import 'package:hive/hive.dart';

import '../../domain/repositories/daily_log_repository.dart';
import '../models/daily_log.dart';

/// Implementation of [DailyLogRepository] using Hive for storage
class DailyLogRepositoryImpl implements DailyLogRepository {
  final Box<DailyLog> _dailyLogBox;

  /// Constructs a DailyLogRepositoryImpl with the required Hive box
  DailyLogRepositoryImpl(this._dailyLogBox);

  @override
  Future<DailyLog?> getDailyLog(DateTime date) async {
    final dateStr = _formatDate(date);
    return _dailyLogBox.get(dateStr);
  }

  @override
  Future<List<DailyLog>> getAllDailyLogs() async {
    return _dailyLogBox.values.toList();
  }

  @override
  Future<void> saveDailyLog(DailyLog dailyLog) async {
    await _dailyLogBox.put(dailyLog.id, dailyLog);
  }

  @override
  Future<void> deleteDailyLog(String id) async {
    await _dailyLogBox.delete(id);
  }

  /// Helper method to format date to year-month-day string for ID
  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }
}

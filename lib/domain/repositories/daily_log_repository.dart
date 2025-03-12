import '../../data/models/daily_log.dart';

/// Repository interface for daily log operations
abstract class DailyLogRepository {
  /// Get a daily log for a specific date
  Future<DailyLog?> getDailyLog(DateTime date);

  /// Get all daily logs
  Future<List<DailyLog>> getAllDailyLogs();

  /// Save a daily log
  Future<void> saveDailyLog(DailyLog dailyLog);

  /// Delete a daily log
  Future<void> deleteDailyLog(String id);
}

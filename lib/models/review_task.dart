import 'package:flutter/foundation.dart';

const List<int> kReviewSteps = [1, 3, 7, 14, 30];

class ReviewTask {
  final String id;
  String title;
  bool isLearned;
  DateTime? learnedAt;
  int currentStageIndex; // -1 = chưa học, 0..4 = đang ở mốc, 5 = hoàn thành tất cả mốc
  bool isCompleted; // true khi đã ôn xong mốc 30d

  ReviewTask({
    required this.id,
    required this.title,
    this.isLearned = false,
    this.learnedAt,
    this.currentStageIndex = -1,
    this.isCompleted = false,
  });

  int? get currentStepDay {
    if (!isLearned) return null;
    if (isCompleted) return null;
    if (currentStageIndex < 0 || currentStageIndex >= kReviewSteps.length) return null;
    return kReviewSteps[currentStageIndex];
  }

  DateTime? get nextReviewDate {
    if (learnedAt == null || currentStepDay == null) return null;
    return learnedAt!.add(Duration(days: currentStepDay!));
  }

  bool get isDueToday {
    if (isCompleted) return false; // đã hoàn thành → không còn due
    final next = nextReviewDate;
    if (next == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reviewDay = DateTime(next.year, next.month, next.day);
    return !reviewDay.isAfter(today);
  }

  bool get isOverdue {
    if (isCompleted) return false;
    final next = nextReviewDate;
    if (next == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reviewDay = DateTime(next.year, next.month, next.day);
    return reviewDay.isBefore(today);
  }

  List<MapEntry<int, DateTime>> get fullScheduleDates {
    if (learnedAt == null) return [];
    return kReviewSteps.map((step) {
      return MapEntry(step, learnedAt!.add(Duration(days: step)));
    }).toList();
  }

  void markLearned() {
    isLearned = true;
    isCompleted = false;
    learnedAt = DateTime.now();
    currentStageIndex = 0;
  }

  void cancelLearned() {
    isLearned = false;
    isCompleted = false;
    learnedAt = null;
    currentStageIndex = -1;
  }

  // Advance lên mốc tiếp theo; nếu đang ở mốc cuối (30d) thì mark completed
  void advanceStage() {
    if (isCompleted) return;
    if (currentStageIndex >= kReviewSteps.length - 1) {
      // Đã ôn xong mốc 30d → hoàn thành
      isCompleted = true;
      currentStageIndex = kReviewSteps.length; // 5 = sentinel "done"
    } else {
      currentStageIndex++;
    }
  }
}

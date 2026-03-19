import 'package:flutter/foundation.dart';
import '../models/review_task.dart';
import '../data/demo_tasks.dart';

class TaskStore extends ChangeNotifier {
  List<ReviewTask> _tasks = buildDemoTasks();
  // Track tasks đã ôn xong hôm nay (ẩn khỏi home)
  final Set<String> _reviewedTodayIds = {};

  List<ReviewTask> get tasks => List.unmodifiable(_tasks);

  List<ReviewTask> get learnedTasks => _tasks.where((t) => t.isLearned).toList();

  List<ReviewTask> get dueTodayTasks => _tasks.where((t) => t.isDueToday).toList();

  // Task đến hạn hôm nay nhưng chưa bấm "Đã ôn" → hiện trên Home
  List<ReviewTask> get pendingReviewTasks =>
      _tasks.where((t) => t.isDueToday && !_reviewedTodayIds.contains(t.id)).toList();

  // Số task chưa ôn (đến hạn mà chưa ôn)
  int get notReviewedCount => pendingReviewTasks.length;

  int get totalCount => _tasks.length;
  int get learnedCount => learnedTasks.length;
  int get dueTodayCount => dueTodayTasks.length;

  List<ReviewTask> get notLearnedTasks => _tasks.where((t) => !t.isLearned).toList();

  bool isReviewedToday(String id) => _reviewedTodayIds.contains(id);

  void markLearned(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _tasks[idx].markLearned();
    notifyListeners();
  }

  void cancelLearned(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _tasks[idx].cancelLearned();
    _reviewedTodayIds.remove(id);
    notifyListeners();
  }

  // Đánh dấu đã ôn hôm nay → ẩn khỏi home, advance stage
  void markReviewedToday(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _reviewedTodayIds.add(id);
    _tasks[idx].advanceStage();
    notifyListeners();
  }

  void addTask(String title) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final task = ReviewTask(id: id, title: title)..markLearned();
    _tasks.insert(0, task);
    notifyListeners();
  }

  void renameTask(String id, String newTitle) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _tasks[idx].title = newTitle;
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _reviewedTodayIds.remove(id);
    notifyListeners();
  }
}

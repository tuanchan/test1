import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/demo_tasks.dart';
import '../models/review_task.dart';

const _kTasksKey = 'tasks_v1';

class TaskStore extends ChangeNotifier {
  List<ReviewTask> _tasks = [];
  final Set<String> _reviewedTodayIds = {};
  bool _loaded = false;

  TaskStore() {
    _loadTasks();
  }

  bool get isLoaded => _loaded;

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kTasksKey);
    if (raw != null && raw.isNotEmpty) {
      final list = jsonDecode(raw) as List<dynamic>;
      _tasks = list
          .map((e) => ReviewTask.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } else {
      _tasks = buildDemoTasks();
      await _saveTasks();
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_kTasksKey, raw);
  }

  List<ReviewTask> get tasks => List.unmodifiable(_tasks);

  List<ReviewTask> get learnedTasks => _tasks.where((t) => t.isLearned).toList();

  List<ReviewTask> get dueTodayTasks => _tasks.where((t) => t.isDueToday).toList();

  List<ReviewTask> get pendingReviewTasks =>
      _tasks.where((t) => t.isDueToday && !_reviewedTodayIds.contains(t.id)).toList();

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
    _saveTasks();
    notifyListeners();
  }

  void cancelLearned(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _tasks[idx].cancelLearned();
    _reviewedTodayIds.remove(id);
    _saveTasks();
    notifyListeners();
  }

  void markReviewedToday(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _reviewedTodayIds.add(id);
    _tasks[idx].advanceStage();
    _saveTasks();
    notifyListeners();
  }

  void addTask(String title) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final task = ReviewTask(id: id, title: title)..markLearned();
    _tasks.insert(0, task);
    _saveTasks();
    notifyListeners();
  }

  void renameTask(String id, String newTitle) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    _tasks[idx].title = newTitle;
    _saveTasks();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _reviewedTodayIds.remove(id);
    _saveTasks();
    notifyListeners();
  }
}

import '../models/review_task.dart';

List<ReviewTask> buildDemoTasks() {
  final now = DateTime.now();
  return [
    ReviewTask(id: '1', title: 'Task Alpha - Group 1',
        isLearned: true, learnedAt: now.subtract(const Duration(days: 1)),
        currentStageIndex: 0),
    ReviewTask(id: '2', title: 'Task Beta - Group 1',
        isLearned: true, learnedAt: now.subtract(const Duration(days: 3)),
        currentStageIndex: 1),
    ReviewTask(id: '3', title: 'Task Gamma - Group 2',
        isLearned: true, learnedAt: now.subtract(const Duration(days: 7)),
        currentStageIndex: 2),
    ReviewTask(id: '4', title: 'Task Delta - Group 2',
        isLearned: true, learnedAt: now.subtract(const Duration(days: 14)),
        currentStageIndex: 3),
    ReviewTask(id: '5', title: 'Task Epsilon - Group 3'),
    ReviewTask(id: '6', title: 'Task Zeta - Group 3'),
    // Stage 30d done -> isCompleted = true -> no longer appears as due
    ReviewTask(id: '7', title: 'Task Eta - Group 4',
        isLearned: true, learnedAt: now.subtract(const Duration(days: 30)),
        currentStageIndex: kReviewSteps.length, // sentinel done
        isCompleted: true),
    ReviewTask(id: '8', title: 'Task Theta - Group 4'),
    ReviewTask(id: '9', title: 'Task Iota - Group 5',
        isLearned: true, learnedAt: now.subtract(const Duration(days: 2)),
        currentStageIndex: 0),
    ReviewTask(id: '10', title: 'Task Kappa - Group 5'),
    ReviewTask(id: '11', title: 'Task Lambda - Group 6',
        isLearned: true, learnedAt: now.subtract(const Duration(days: 6)),
        currentStageIndex: 1),
    ReviewTask(id: '12', title: 'Task Mu - Group 6'),
  ];
}

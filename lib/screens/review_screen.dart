import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/task_store.dart';
import '../models/review_task.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart' as du;
import '../widgets/review_timeline.dart';
import '../widgets/empty_state.dart';
import '../sheets/today_review_sheet.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskStore>().dueTodayTasks;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Review', style: AppTextStyles.largeTitle),
                        Text('Today: ${tasks.length} task',
                            style: AppTextStyles.bodySecondary),
                      ],
                    ),
                  ),
                  if (tasks.isNotEmpty)
                    GestureDetector(
                      onTap: () => showTodayReviewSheet(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.accentDim,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Details', style: AppTextStyles.caption.copyWith(
                            color: AppColors.accent, fontWeight: FontWeight.w600)),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: tasks.isEmpty
                  ? const EmptyState(
                      title: 'Nothing today',
                      subtitle: "Great! You're done or nothing is due.",
                      icon: CupertinoIcons.checkmark_seal_fill)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                      itemCount: tasks.length,
                      itemBuilder: (_, i) => _ReviewCard(task: tasks[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewTask task;
  const _ReviewCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(task.title,
                    style: AppTextStyles.title2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.isOverdue ? 'OVERDUE' : 'TODAY',
                  style: AppTextStyles.label.copyWith(color: AppColors.accent, fontSize: 9),
                ),
              ),
            ],
          ),
          if (task.nextReviewDate != null) ...[
            const SizedBox(height: 5),
            Text(
              'Review: ${du.formatDate(task.nextReviewDate!)}  ·  Stage ${task.currentStageIndex + 1}/5',
              style: AppTextStyles.caption.copyWith(
                  color: AppColors.warningDue, fontSize: 11),
            ),
          ],
          const SizedBox(height: 10),
          ReviewTimeline(task: task),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => showTodayReviewSheet(context),
            child: Container(
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.accentDim,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('See full schedule',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.accent, fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}

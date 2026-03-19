import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/task_store.dart';
import '../models/review_task.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart' as du;
import '../widgets/review_timeline.dart';
import '../widgets/empty_state.dart';

void showTodayReviewSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ChangeNotifierProvider.value(
      value: context.read<TaskStore>(),
      child: const _Sheet(),
    ),
  );
}

class _Sheet extends StatelessWidget {
  const _Sheet();

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskStore>().dueTodayTasks;
    final maxH = MediaQuery.of(context).size.height * 0.75;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          constraints: BoxConstraints(maxHeight: maxH),
          decoration: BoxDecoration(
            color: AppColors.elevated.withOpacity(0.93),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              const SizedBox(height: 10),
              Center(child: Container(
                width: 32, height: 3,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              )),
              const SizedBox(height: 14),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Expanded(child: Text('Need to review today', style: AppTextStyles.title1)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(CupertinoIcons.xmark_circle_fill,
                          color: AppColors.textSecondary, size: 22),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('${tasks.length} task', style: AppTextStyles.bodySecondary),
                ),
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: AppColors.border),
              // List
              Flexible(
                child: tasks.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: EmptyState(
                          title: 'Nothing to review',
                          subtitle: "You're free today!",
                          icon: CupertinoIcons.checkmark_seal_fill,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        itemBuilder: (_, i) => _Item(task: tasks[i]),
                      ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final ReviewTask task;
  const _Item({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title, style: AppTextStyles.title2),
          const SizedBox(height: 6),
          // Meta: bắt đầu + mốc + ngày ôn
          if (task.learnedAt != null)
            Text(
              'Started: ${du.formatDate(task.learnedAt!)}  -  Stage ${task.currentStageIndex + 1}/5  -  Review: ${task.nextReviewDate != null ? du.formatDate(task.nextReviewDate!) : "-"}',
              style: AppTextStyles.caption.copyWith(
                  color: AppColors.accent, fontSize: 11),
            ),
          const SizedBox(height: 12),
          // Divider
          Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),
          Text('REVIEW SCHEDULE', style: AppTextStyles.label.copyWith(fontSize: 9)),
          const SizedBox(height: 8),
          FullReviewTimeline(task: task),
        ],
      ),
    );
  }
}

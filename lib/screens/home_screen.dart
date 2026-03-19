import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/task_store.dart';
import '../models/review_task.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart' as du;
import '../widgets/review_timeline.dart';
import '../sheets/today_review_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TaskStore>();
    final pending = store.pendingReviewTasks;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
          children: [
            Text('SpacedRep', style: AppTextStyles.largeTitle),
            const SizedBox(height: 2),
            Text('Spaced repetition schedule', style: AppTextStyles.bodySecondary),
            const SizedBox(height: 20),

            // 3 stat boxes
            Row(
              children: [
                _StatBox(
                  value: '${store.totalCount}',
                  label: 'Total',
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                _StatBox(
                  value: '${store.notReviewedCount}',
                  label: 'Not reviewed',
                  color: store.notReviewedCount > 0 ? AppColors.accent : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                _StatBox(
                  value: '${store.dueTodayCount}',
                  label: 'Review today',
                  color: store.dueTodayCount > 0 ? AppColors.warningDue : AppColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section: cần ôn hôm nay
            Row(
              children: [
                Expanded(
                  child: Text(
                    pending.isEmpty ? "Today's reviews done" : 'Review today',
                    style: AppTextStyles.title2,
                  ),
                ),
                if (store.dueTodayCount > 0)
                  GestureDetector(
                    onTap: () => showTodayReviewSheet(context),
                    child: Text('View schedule',
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.accent, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            if (pending.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(CupertinoIcons.checkmark_seal_fill,
                        color: AppColors.success, size: 28),
                    const SizedBox(height: 8),
                    Text('All reviewed!',
                        style: AppTextStyles.body.copyWith(color: AppColors.success)),
                    const SizedBox(height: 4),
                    Text('No tasks left to review today.',
                        style: AppTextStyles.bodySecondary.copyWith(fontSize: 12)),
                  ],
                ),
              )
            else
              ...pending.map((t) => _HomeTaskCard(task: t)),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatBox({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: AppTextStyles.title1.copyWith(color: color, fontSize: 22)),
            const SizedBox(height: 2),
            Text(label,
                style: AppTextStyles.label.copyWith(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _HomeTaskCard extends StatelessWidget {
  final ReviewTask task;
  const _HomeTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final store = context.read<TaskStore>();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withOpacity(0.35)),
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
                  style: AppTextStyles.label.copyWith(
                      color: AppColors.accent, fontSize: 9),
                ),
              ),
            ],
          ),
          if (task.nextReviewDate != null) ...[
            const SizedBox(height: 5),
            Text(
              'Review: ${du.formatDate(task.nextReviewDate!)}  -  Stage ${task.currentStageIndex + 1}/5',
              style: AppTextStyles.caption.copyWith(
                  color: AppColors.warningDue, fontSize: 11),
            ),
          ],
          const SizedBox(height: 10),
          ReviewTimeline(task: task),
          const SizedBox(height: 10),
          // Nút Đã ôn
          GestureDetector(
            onTap: () => store.markReviewedToday(task.id),
            child: Container(
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Reviewed',
                style: AppTextStyles.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

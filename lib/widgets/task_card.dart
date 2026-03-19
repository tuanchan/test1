import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/review_task.dart';
import '../state/task_store.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart' as du;
import '../widgets/review_timeline.dart';
import '../dialogs/cancel_learned_dialog.dart';

class TaskCard extends StatelessWidget {
  final ReviewTask task;
  final bool isReviewedToday;
  final VoidCallback? onEditTap;
  const TaskCard({
    super.key,
    required this.task,
    this.isReviewedToday = false,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final store = context.read<TaskStore>();
    final isDue = task.isDueToday;
    final isLearned = task.isLearned;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDue ? AppColors.accent.withOpacity(0.4) : AppColors.border,
          width: isDue ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: title + badge
            Row(
              children: [
                Expanded(
                  child: Text(task.title,
                      style: AppTextStyles.title2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 6),
                _badge(task),
                const SizedBox(width: 4),
                if (onEditTap != null)
                  GestureDetector(
                    onTap: onEditTap,
                    child: const Icon(CupertinoIcons.pencil,
                        size: 14, color: AppColors.textSecondary),
                  ),
              ],
            ),

            // Row 2: ngày ôn (chỉ khi đã học)
            if (isLearned && task.nextReviewDate != null) ...[
              const SizedBox(height: 6),
              Text(
                'Review: ${du.formatDate(task.nextReviewDate!)}  -  Stage ${task.currentStageIndex + 1}/5',
                style: AppTextStyles.caption.copyWith(
                  color: isDue ? AppColors.warningDue : AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 10),
              // Timeline
              ReviewTimeline(task: task),
              const SizedBox(height: 10),
            ] else
              const SizedBox(height: 10),

            // Row 3: 2 nút
            Row(
              children: [
                Expanded(
                  child: _Btn(
                    label: 'Mark learned',
                    filled: !isLearned,
                    enabled: !isLearned,
                    onTap: !isLearned ? () => store.markLearned(task.id) : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _Btn(
                    label: 'Unlearn',
                    filled: false,
                    enabled: isLearned,
                    onTap: isLearned
                        ? () async {
                            final ok = await showCancelLearnedDialog(context, task.title);
                            if (ok) store.cancelLearned(task.id);
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(ReviewTask task) {
    if (!task.isLearned) {
      return _BadgeChip(label: 'NOT LEARNED', color: AppColors.textSecondary);
    }
    if (task.isCompleted) {
      return _BadgeChip(label: 'COMPLETED', color: AppColors.success);
    }
    if (isReviewedToday) {
      return _BadgeChip(label: 'REVIEWED', color: AppColors.success);
    }
    if (task.isOverdue) {
      return _BadgeChip(label: 'OVERDUE', color: AppColors.accent);
    }
    if (task.isDueToday) {
      return _BadgeChip(label: 'TODAY', color: AppColors.accent);
    }
    return _BadgeChip(label: 'LEARNING', color: AppColors.success);
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  final Color color;
  const _BadgeChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: AppTextStyles.label.copyWith(color: color, fontSize: 9)),
    );
  }
}

class _Btn extends StatelessWidget {
  final String label;
  final bool filled;
  final bool enabled;
  final VoidCallback? onTap;
  const _Btn({required this.label, required this.filled, required this.enabled, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.3,
        child: Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: filled ? Colors.transparent : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: filled ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

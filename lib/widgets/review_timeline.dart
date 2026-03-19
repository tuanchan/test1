import 'package:flutter/material.dart';
import '../models/review_task.dart';
import '../theme/app_theme.dart';
import '../utils/date_utils.dart' as du;

class ReviewTimeline extends StatelessWidget {
  final ReviewTask task;
  const ReviewTimeline({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    if (!task.isLearned || task.learnedAt == null) return const SizedBox.shrink();
    final schedule = task.fullScheduleDates;
    final now = DateTime.now();

    return Row(
      children: schedule.asMap().entries.map((e) {
        final i = e.key;
        final step = e.value.key;
        final date = e.value.value;
        final isPast = date.isBefore(now) && !du.isSameDay(date, now);
        final isToday = du.isSameDay(date, now);
        final isCurrent = i == task.currentStageIndex;

        Color dotColor;
        if (task.isCompleted) {
          dotColor = AppColors.success.withOpacity(0.8);
        } else if (isCurrent && isToday) {
          dotColor = AppColors.accent;
        } else if (isCurrent) {
          dotColor = AppColors.warningDue;
        } else if (isPast && i < task.currentStageIndex) {
          dotColor = AppColors.success.withOpacity(0.7);
        } else {
          dotColor = AppColors.border;
        }

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (i > 0)
                    Expanded(
                      child: Container(
                        height: 1,
                        color: (isPast && i <= task.currentStageIndex)
                            ? AppColors.success.withOpacity(0.4)
                            : AppColors.border,
                      ),
                    ),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (i < schedule.length - 1) const Expanded(child: SizedBox()),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${step}d',
                style: AppTextStyles.label.copyWith(
                  color: isCurrent ? dotColor : AppColors.textSecondary.withOpacity(0.5),
                  fontSize: 9,
                ),
              ),
              Text(
                du.formatDateShort(date),
                style: AppTextStyles.label.copyWith(
                  color: isCurrent ? dotColor : AppColors.textSecondary.withOpacity(0.4),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class FullReviewTimeline extends StatelessWidget {
  final ReviewTask task;
  const FullReviewTimeline({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    if (!task.isLearned || task.learnedAt == null) return const SizedBox.shrink();
    final schedule = task.fullScheduleDates;
    final now = DateTime.now();

    return Column(
      children: schedule.asMap().entries.map((e) {
        final i = e.key;
        final step = e.value.key;
        final date = e.value.value;
        final isPast = date.isBefore(now) && !du.isSameDay(date, now);
        final isToday = du.isSameDay(date, now);
        final isCurrent = i == task.currentStageIndex;

        Color color;
        String? tag;
        if (isCurrent && isToday) {
          color = AppColors.accent;
          tag = 'TODAY';
        } else if (isCurrent && isPast) {
          color = AppColors.accent;
          tag = 'OVERDUE';
        } else if (i < task.currentStageIndex) {
          color = AppColors.success;
          tag = null;
        } else {
          color = AppColors.border;
          tag = null;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Container(
                width: 32,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: color == AppColors.border ? AppColors.surface : color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${step}d',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label.copyWith(
                    color: color == AppColors.border ? AppColors.textSecondary : color,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  du.formatDate(date),
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    color: isCurrent ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
              if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: AppTextStyles.label.copyWith(color: color, fontSize: 9),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

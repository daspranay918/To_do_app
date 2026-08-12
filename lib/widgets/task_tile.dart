import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  String _formatDateTime(BuildContext context) {
    if (task.dateTime == null) {
      return '';
    }

    final date = task.dateTime!;
    final now = DateTime.now();

    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final yesterday = now.subtract(const Duration(days: 1));

    final isYesterday =
        date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;

    String dayText;

    if (isToday) {
      dayText = 'Today';
    } else if (isYesterday) {
      dayText = 'Yesterday';
    } else {
      dayText =
          '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    }

    final time = TimeOfDay.fromDateTime(date);

    return '$dayText, ${time.format(context)}';
  }

  @override
  Widget build(BuildContext context) {
    final hasDateTime = task.dateTime != null;

    return Dismissible(
      key: ObjectKey(task),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.delete,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.065),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              _AnimatedCheckbox(isCompleted: task.isCompleted, onTap: onToggle),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: task.isCompleted
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      child: Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (hasDateTime) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _formatDateTime(context),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onDelete,
                tooltip: 'Delete task',
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 19,
                  color: AppColors.delete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedCheckbox extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onTap;

  const _AnimatedCheckbox({required this.isCompleted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: Center(
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? AppColors.completed : Colors.transparent,
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.completed
                        : AppColors.primary,
                    width: 1.4,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          key: ValueKey('checked'),
                          size: 14,
                          color: Colors.white,
                        )
                      : const SizedBox(key: ValueKey('unchecked')),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

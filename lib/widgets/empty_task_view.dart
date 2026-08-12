import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class EmptyTaskView extends StatelessWidget {
  final bool isFiltered;

  const EmptyTaskView({super.key, this.isFiltered = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final illustrationSize = constraints.maxWidth < 260 ? 180.0 : 220.0;

        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
            child: Column(
              children: [
                _buildIllustration(illustrationSize),
                const SizedBox(height: 25),
                Text(
                  isFiltered ? 'No tasks found' : 'No tasks yet!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isFiltered
                      ? 'There are no tasks in this category.'
                      : 'Add a task above and\nget started.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIllustration(double size) {
    final scale = size / 220;

    return SizedBox(
      width: size,
      height: size,
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.04),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 52,
                child: Container(
                  width: 125,
                  height: 135,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.20),
                      width: 6,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChecklistRow(true),
                      _buildChecklistRow(true),
                      _buildChecklistRow(true),
                      _buildChecklistRow(false),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 38,
                child: Container(
                  width: 42,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
              Positioned(
                top: 29,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight,
                  ),
                ),
              ),
              Positioned(right: 33, bottom: 32, child: _buildPlant()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistRow(bool checked) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: Row(
        children: [
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: checked
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : Colors.transparent,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
            child: checked
                ? const Icon(
                    Icons.check_rounded,
                    size: 11,
                    color: AppColors.primary,
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlant() {
    return SizedBox(
      width: 60,
      height: 85,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 14,
            child: Container(
              width: 34,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                  top: Radius.circular(4),
                ),
              ),
            ),
          ),
          Positioned(
            left: 25,
            top: 25,
            child: Container(
              width: 5,
              height: 42,
              color: AppColors.primaryLight,
            ),
          ),
          Positioned(
            left: 8,
            top: 15,
            child: Transform.rotate(
              angle: -0.6,
              child: Container(
                width: 24,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            right: 3,
            top: 7,
            child: Transform.rotate(
              angle: 0.6,
              child: Container(
                width: 25,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/task_model.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final ValueChanged<TaskModel> onTaskAdded;

  const AddTaskBottomSheet({super.key, required this.onTaskAdded});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _taskController = TextEditingController();

  final FocusNode _taskFocusNode = FocusNode();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _taskController.dispose();
    _taskFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    _taskFocusNode.unfocus();

    await Future.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;

    final now = DateTime.now();

    final pickedDate = await showDatePicker( // calender
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) return;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<void> _selectTime() async {
    _taskFocusNode.unfocus();

    await Future.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime == null || !mounted) return;

    setState(() {
      _selectedTime = pickedTime;
    });
  }

  void _addTask() {
    final title = _taskController.text.trim();

    if (title.isEmpty) {
      _taskFocusNode.requestFocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task'),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    DateTime? taskDateTime;

    if (_selectedDate != null) {
      taskDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime?.hour ?? 0,
        _selectedTime?.minute ?? 0,
      );
    }

    widget.onTaskAdded(TaskModel(title: title, dateTime: taskDateTime));

    Navigator.of(context).pop();
  }

  String _formatDate() {
    if (_selectedDate == null) {
      return 'Select date';
    }

    return '${_selectedDate!.day.toString().padLeft(2, '0')}/'
        '${_selectedDate!.month.toString().padLeft(2, '0')}/'
        '${_selectedDate!.year}';
  }

  String _formatTime() {
    if (_selectedTime == null) {
      return 'Select time';
    }

    return _selectedTime!.format(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    final screenHeight = MediaQuery.sizeOf(context).height;

    final availableHeight = screenHeight - keyboardHeight;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Material(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black26,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: availableHeight * 0.9),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHandle(),
                  const SizedBox(height: 22),
                  const Text(
                    'Add New Task',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _buildTaskField(),
                  const SizedBox(height: 22),
                  const Text(
                    'Select Date & Time',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDateTimeButtons(),
                  const SizedBox(height: 24),
                  _buildAddButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 48,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildTaskField() {
    return TextField(
      controller: _taskController,
      focusNode: _taskFocusNode,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _addTask(),
      decoration: InputDecoration(
        hintText: 'Enter your task',
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 15,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDateTimeButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360) {
          return Column(
            children: [
              _SelectionButton(
                icon: Icons.calendar_today_outlined,
                label: _formatDate(),
                isSelected: _selectedDate != null,
                onTap: _selectDate,
              ),
              const SizedBox(height: 10),
              _SelectionButton(
                icon: Icons.access_time_rounded,
                label: _formatTime(),
                isSelected: _selectedTime != null,
                onTap: _selectTime,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _SelectionButton(
                icon: Icons.calendar_today_outlined,
                label: _formatDate(),
                isSelected: _selectedDate != null,
                onTap: _selectDate,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SelectionButton(
                icon: Icons.access_time_rounded,
                label: _formatTime(),
                isSelected: _selectedTime != null,
                onTap: _selectTime,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: _addTask,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'Add Task',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _SelectionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 19, color: AppColors.textPrimary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

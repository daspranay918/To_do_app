import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../models/task_model.dart';
import '../services/task_storage.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/empty_task_view.dart';
import '../widgets/task_input.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TaskModel> _tasks = [];

  String _selectedFilter = 'All';
  bool _isLoading = true;

  List<TaskModel> get _filteredTasks {
    switch (_selectedFilter) {
      case 'Active':
        return _tasks.where((task) => !task.isCompleted).toList();

      case 'Completed':
        return _tasks.where((task) => task.isCompleted).toList();

      default:
        return _tasks;
    }
  }

  int get _activeTaskCount {
    return _tasks.where((task) => !task.isCompleted).length;
  }

  int get _completedTaskCount {
    return _tasks.where((task) => task.isCompleted).length;
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await TaskStorage.loadTasks();

    if (!mounted) return;

    setState(() {
      _tasks
        ..clear()
        ..addAll(tasks);
      _isLoading = false;
    });
  }

  Future<void> _saveTasks() {
    return TaskStorage.saveTasks(_tasks);
  }

  Future<void> _addTask(TaskModel task) async {
    setState(() {
      _tasks.insert(0, task);
      _selectedFilter = 'All';
    });

    await _saveTasks();
  }

  Future<void> _toggleTask(TaskModel task) async {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });

    await _saveTasks();
  }

  Future<void> _deleteTask(TaskModel task) async {
    final index = _tasks.indexOf(task);

    if (index == -1) return;

    setState(() {
      _tasks.removeAt(index);
    });

    await _saveTasks();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            if (!mounted) return;

            setState(() {
              _tasks.insert(index.clamp(0, _tasks.length), task);
            });

            await _saveTasks();
          },
        ),
      ),
    );
  }

  void _showAddTaskSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      useSafeArea: false,
      barrierColor: Colors.black54,
      builder: (_) {
        return AddTaskBottomSheet(onTaskAdded: _addTask);
      },
    );
  }

  void _selectFilter(String filter) {
    if (_selectedFilter == filter) return;

    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded),
        ),
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingAddButton(),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  final contentWidth = constraints.maxWidth > 700
                      ? 680.0
                      : constraints.maxWidth;

                  return Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: contentWidth,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildGreeting(),
                            const SizedBox(height: 18),
                            TaskInput(onTap: _showAddTaskSheet),
                            const SizedBox(height: 18),
                            _buildFilters(),
                            const SizedBox(height: 18),
                            _buildTaskContent(filteredTasks),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildFloatingAddButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _showAddTaskSheet,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
    );
  }

  Widget _buildGreeting() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning, 👋',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Let's get things done.",
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildFilter(label: 'All', count: _tasks.length),
        _buildFilter(label: 'Active', count: _activeTaskCount),
        _buildFilter(label: 'Completed', count: _completedTaskCount),
      ],
    );
  }

  Widget _buildFilter({required String label, required int count}) {
    final isSelected = _selectedFilter == label;

    return GestureDetector(
      onTap: () => _selectFilter(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.08 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskContent(List<TaskModel> tasks) {
    if (tasks.isEmpty) {
      return EmptyTaskView(
        key: ValueKey('empty-$_selectedFilter'),
        isFiltered: _tasks.isNotEmpty && _selectedFilter != 'All',
      );
    }

    return _buildTaskList(tasks);
  }

  Widget _buildTaskList(List<TaskModel> tasks) {
    return Column(
      key: const ValueKey('task-list'),
      children: [
        for (final task in tasks)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TaskTile(
              task: task,
              onToggle: () => _toggleTask(task),
              onDelete: () => _deleteTask(task),
            ),
          ),
      ],
    );
  }
}

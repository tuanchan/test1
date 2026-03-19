import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/task_store.dart';
import '../models/review_task.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/empty_state.dart';
import '../dialogs/cancel_learned_dialog.dart';

const _stageFilters = [null, 0, 1, 2, 3, 4];
const _stageLabels = ['All', '1d', '3d', '7d', '14d', '30d'];

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  int _stageFilter = 0;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ReviewTask> _apply(List<ReviewTask> tasks) {
    var list = tasks.toList();
    final stageIdx = _stageFilters[_stageFilter];
    if (stageIdx != null) {
      list = list.where((t) => t.isLearned && t.currentStageIndex == stageIdx).toList();
    }
    if (_query.trim().isNotEmpty) {
      final q = _query.trim().toLowerCase();
      list = list.where((t) => t.title.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<TaskStore>();
    final filtered = _apply(store.tasks);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tasks', style: AppTextStyles.largeTitle),
                      Text('${store.totalCount} task', style: AppTextStyles.bodySecondary),
                      const SizedBox(height: 12),

                      // Search bar
                      Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            const Icon(CupertinoIcons.search,
                                size: 15, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchCtrl,
                                onChanged: (v) => setState(() => _query = v),
                                style: AppTextStyles.body.copyWith(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: 'Search tasks...',
                                  hintStyle: AppTextStyles.bodySecondary.copyWith(fontSize: 13),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            if (_query.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchCtrl.clear();
                                  setState(() => _query = '');
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(CupertinoIcons.xmark_circle_fill,
                                      size: 15, color: AppColors.textSecondary),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Mốc filter
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(_stageLabels.length, (i) {
                            final active = _stageFilter == i;
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: i < _stageLabels.length - 1 ? 6 : 0),
                              child: GestureDetector(
                                onTap: () => setState(() => _stageFilter = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 160),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: active
                                        ? AppColors.accent.withOpacity(0.15)
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: active
                                          ? AppColors.accent.withOpacity(0.5)
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Text(_stageLabels[i],
                                      style: AppTextStyles.caption.copyWith(
                                        color: active
                                            ? AppColors.accent
                                            : AppColors.textSecondary,
                                        fontWeight: active
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        fontSize: 12,
                                      )),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: filtered.isEmpty
                      ? EmptyState(
                          title: 'Not found',
                          subtitle: _query.isNotEmpty
                              ? 'No tasks match "$_query"'
                              : 'No tasks at this stage',
                          icon: CupertinoIcons.square_list,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 120),
                          itemCount: filtered.length,
                          itemBuilder: (ctx, i) {
                            final task = filtered[i];
                            return _SwipeTaskCard(
                              task: task,
                              key: ValueKey(task.id),
                            );
                          },
                        ),
                ),
              ],
            ),

            // FAB
            Positioned(
              right: 18,
              bottom: 90,
              child: _AddTaskFab(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Swipe card: swipe trái = xóa, tap giữ = edit ───────────────────────────

class _SwipeTaskCard extends StatelessWidget {
  final ReviewTask task;
  const _SwipeTaskCard({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    final reviewed = Provider.of<TaskStore>(context, listen: false).isReviewedToday(task.id);
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        Provider.of<TaskStore>(context, listen: false).deleteTask(task.id);
      },
      // Nền đỏ khi swipe
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFD32F2F),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.trash_fill, color: Colors.white, size: 20),
            SizedBox(height: 4),
            Text('Delete', style: TextStyle(
              color: Colors.white, fontSize: 11,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            )),
          ],
        ),
      ),
      // Card có thêm nút edit ở góc
      child: _TaskCardWithActions(task: task, isReviewedToday: reviewed),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Delete task?'),
        content: Text('Deleting "${task.title}" cannot be undone.'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

// TaskCard wrapper thêm nút edit tên
class _TaskCardWithActions extends StatelessWidget {
  final ReviewTask task;
  final bool isReviewedToday;
  const _TaskCardWithActions({required this.task, required this.isReviewedToday});

  @override
  Widget build(BuildContext context) {
    return TaskCard(
      task: task,
      isReviewedToday: isReviewedToday,
      onEditTap: () => _showEditSheet(context),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: Provider.of<TaskStore>(context, listen: false),
        child: _EditTaskSheet(task: task),
      ),
    );
  }
}

// ─── Bottom sheet sửa tên ─────────────────────────────────────────────────────

class _EditTaskSheet extends StatefulWidget {
  final ReviewTask task;
  const _EditTaskSheet({required this.task});
  @override
  State<_EditTaskSheet> createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<_EditTaskSheet> {
  late final TextEditingController _ctrl;
  bool _unchanged = true;
  bool _empty = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.task.title);
    _ctrl.addListener(() {
      setState(() {
        _unchanged = _ctrl.text.trim() == widget.task.title.trim();
        _empty = _ctrl.text.trim().isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    final title = _ctrl.text.trim();
    if (title.isEmpty || _unchanged) return;
    Provider.of<TaskStore>(context, listen: false).renameTask(widget.task.id, title);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final canSave = !_unchanged && !_empty;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.elevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 32, height: 3,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text('Rename task', style: AppTextStyles.title1)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(CupertinoIcons.xmark_circle_fill,
                      color: AppColors.textSecondary, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: canSave
                      ? AppColors.accent.withOpacity(0.5)
                      : AppColors.border,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextField(
                controller: _ctrl,
                autofocus: true,
                onSubmitted: (_) => _save(),
                style: AppTextStyles.body.copyWith(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Task name...',
                  hintStyle: AppTextStyles.bodySecondary.copyWith(fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: canSave ? _save : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: canSave ? AppColors.accent : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: canSave ? Colors.transparent : AppColors.border,
                  ),
                ),
                child: Text('Save',
                    style: AppTextStyles.body.copyWith(
                      color: canSave ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    )),
              ),
            ),

            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final confirm = await showCupertinoDialog<bool>(
                  context: context,
                  builder: (ctx) => CupertinoAlertDialog(
                    title: const Text('Delete task?'),
                    content: Text('Delete "${widget.task.title}" cannot be undone.'),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('No'),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Delete task'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  Provider.of<TaskStore>(context, listen: false).deleteTask(widget.task.id);
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.4)),
                ),
                child: Text(
                  'Delete task',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.red.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── FAB + Sheet tạo task ─────────────────────────────────────────────────────

class _AddTaskFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddSheet(context),
      child: Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
          color: AppColors.accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(CupertinoIcons.plus, color: Colors.white, size: 24),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: Provider.of<TaskStore>(context, listen: false),
        child: const _AddTaskSheet(),
      ),
    );
  }
}

class _AddTaskSheet extends StatefulWidget {
  const _AddTaskSheet();
  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _ctrl = TextEditingController();
  bool _empty = true;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _ctrl.text.trim();
    if (title.isEmpty) return;
    Provider.of<TaskStore>(context, listen: false).addTask(title);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.elevated,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 32, height: 3,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text('Create task', style: AppTextStyles.title1)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(CupertinoIcons.xmark_circle_fill,
                      color: AppColors.textSecondary, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Review schedule starts from creation: +1d +3d +7d +14d +30d',
              style: AppTextStyles.bodySecondary.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _empty
                      ? AppColors.border
                      : AppColors.accent.withOpacity(0.5),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextField(
                controller: _ctrl,
                autofocus: true,
                onChanged: (v) => setState(() => _empty = v.trim().isEmpty),
                onSubmitted: (_) => _submit(),
                style: AppTextStyles.body.copyWith(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Task name...',
                  hintStyle: AppTextStyles.bodySecondary.copyWith(fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _empty ? null : _submit,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _empty ? AppColors.surface : AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _empty ? AppColors.border : Colors.transparent,
                  ),
                ),
                child: Text('Create task',
                    style: AppTextStyles.body.copyWith(
                      color: _empty ? AppColors.textSecondary : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

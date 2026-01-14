import 'package:flutter/material.dart';
import 'package:shehabapp/features/task_details/task_details_view.dart';
import '../../../core/models/project_tasks_model.dart';
import '../../../l10n/app_localizations.dart';

class DataTableWidget extends StatelessWidget {
  final List<Items> tasks;

  const DataTableWidget({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    if (tasks.isEmpty) {
      return _buildEmptyState(l10n);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: .08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: size.width - 48),
            child: DataTable(
              headingRowHeight: 56,
              dataRowMaxHeight: 64,
              columnSpacing: 24,
              horizontalMargin: 20,
              headingRowColor: WidgetStateProperty.all(
                const Color(0xFF4F46E5).withValues(alpha: .05),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              columns: [
                _buildDataColumn(l10n.stage, Icons.layers),
                _buildDataColumn(l10n.operation, Icons.settings),
                _buildDataColumn(l10n.explanation, Icons.description),
                _buildDataColumn(l10n.done, Icons.check_circle),
                _buildDataColumn(l10n.date, Icons.calendar_today),
              ],
              rows: tasks.asMap().entries.map((entry) {
                final index = entry.key;
                final task = entry.value;
                return _buildDataRow(context, task, index);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(String label, IconData icon) {
    return DataColumn(
      label: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF4F46E5)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF4F46E5),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context, Items task, int index) {
    return DataRow(
      onSelectChanged: (_) {
        // Navigate to TaskDetailsView and pass the task item
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsView(taskItem: task),
          ),
        );
      },
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        // لو المهمة مكتملة (doneFlag = 1) → أخضر فاتح
        if (task.doneFlag == 1) {
          return Colors.green[50];
        }
        // لو المهمة غير مكتملة (doneFlag = 0) → أحمر فاتح
        if (task.doneFlag == 0) {
          return Colors.red[50];
        }
        // Default (للحالات الأخرى)
        return Colors.grey[50];
      }),
      cells: [
        DataCell(
          Text(
            task.flowId?.toString() ?? '',
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ),
        DataCell(
          Text(
            task.procOrder?.toString() ?? '',
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              task.procNameA ?? '',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Checkbox(
            value: task.doneFlag == 1,
            onChanged: null, // Read-only checkbox
            activeColor: const Color(0xFF4F46E5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                task.doneDate ?? '',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_outlined,
                size: 48,
                color: Color(0xFF4F46E5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noTasksFound,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

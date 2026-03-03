import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../mng_daily_tasks_details_view.dart';
import '../../../../core/models/proccess_model.dart';
import '../../../../l10n/app_localizations.dart';

class MngDataTableWidget extends StatelessWidget {
  final List<Items> tasks;

  const MngDataTableWidget({super.key, required this.tasks});

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
            color: const Color(0xFF4F46E5).withOpacity(.08),
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
                const Color(0xFF4F46E5).withOpacity(.05),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              columns: [
                _buildDataColumn(
                  l10n.internalNumber,
                  Icons.tag,
                ), // الرقم الداخلي
                _buildDataColumn(l10n.explanation, Icons.description), // الشرح
                _buildDataColumn(
                  l10n.executionDate,
                  Icons.calendar_today,
                ), // تاريخ التنفيذ
                _buildDataColumn(l10n.status, Icons.check_circle), // تم (Flag)
              ],
              rows: tasks.asMap().entries.map((entry) {
                final index = entry.key;
                final task = entry.value;
                return _buildDataRow(context, task, index, l10n);
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

  DataRow _buildDataRow(
    BuildContext context,
    Items task,
    int index,
    AppLocalizations l10n,
  ) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final explanation = isArabic ? task.procNameA : task.procNameE;

    // Format Date
    String formattedDate = '';
    if (task.doneDate != null && task.doneDate.toString().isNotEmpty) {
      try {
        final date = DateTime.parse(task.doneDate.toString());
        formattedDate = DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        formattedDate = task.doneDate.toString();
      }
    }

    return DataRow(
      onSelectChanged: (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MngDailyTasksDetailsView(taskItem: task),
          ),
        );
      },
      color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (task.doneFlag == 1) {
          return Colors.green[50];
        }
        return Colors.red[50];
      }),
      cells: [
        // 1. ContractNo (الرقم الداخلي)
        DataCell(
          Text(
            task.contractNo?.toString() ?? '',
            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
          ),
        ),
        // 2. Explanation (ProcNameA/E)
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              explanation ?? '',
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // 3. Execution Date (DoneDate)
        DataCell(
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                formattedDate,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        // 4. Status Flag (DoneFlag)
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: task.doneFlag == 1
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: task.doneFlag == 1 ? Colors.green : Colors.orange,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  task.doneFlag == 1 ? Icons.check_circle : Icons.pending,
                  size: 14,
                  color: task.doneFlag == 1 ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  task.doneFlag == 1
                      ? l10n.done
                      : l10n.authStatusPending, // Using existing keys for Done/Pending
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: task.doneFlag == 1 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
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

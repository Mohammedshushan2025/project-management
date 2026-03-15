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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5).withOpacity(.05),
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildHeaderCell(l10n.internalNumber, Icons.tag),
                  ),
                  Expanded(
                    flex: 4,
                    child: _buildHeaderCell(l10n.explanation, Icons.description),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildHeaderCell(l10n.executionDate, Icons.calendar_today),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildHeaderCell(l10n.status, Icons.check_circle),
                  ),
                ],
              ),
            ),
            // ListView with Lazy Loading
            ListView.separated(
              shrinkWrap: true, // Allow ListView inside ScrollView (mng_daily_tasks_view provides ScrollView)
              physics: const NeverScrollableScrollPhysics(), // Scroll managed by parent ScrollView
              itemCount: tasks.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _buildCustomDataRow(context, task, l10n);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF4F46E5)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF4F46E5),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomDataRow(
    BuildContext context,
    Items task,
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

    final isDone = task.doneFlag == 1;

    return Material(
      color: isDone ? Colors.green[50] : Colors.red[50], // Match original row colors
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MngDailyTasksDetailsView(taskItem: task),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. ContractNo
              Expanded(
                flex: 2,
                child: Text(
                  task.contractNo?.toString() ?? '',
                  style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // 2. Explanation
              Expanded(
                flex: 4,
                child: Text(
                  explanation ?? '',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // 3. Execution Date
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        formattedDate,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // 4. Status Flag
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDone
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDone ? Colors.green : Colors.orange,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isDone ? Icons.check_circle : Icons.pending,
                          size: 12,
                          color: isDone ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            isDone ? l10n.done : l10n.authStatusPending,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDone ? Colors.green : Colors.orange,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

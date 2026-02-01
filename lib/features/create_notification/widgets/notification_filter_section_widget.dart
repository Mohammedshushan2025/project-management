import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/create_notification_model.dart';
import 'response_status_filter_radio.dart';
import '../../../../l10n/app_localizations.dart';

class NotificationFilterSectionWidget extends StatelessWidget {
  final String? selectedProject;
  final String? selectedOperation;
  final List<Items> notifications;
  final ValueChanged<String?> onProjectChanged;
  final ValueChanged<String?> onOperationChanged;
  final ResponseStatus selectedStatus;
  final ValueChanged<ResponseStatus> onStatusChanged;
  final VoidCallback onResetPressed;
  final VoidCallback onSearchPressed;
  final bool isSearchEnabled;

  const NotificationFilterSectionWidget({
    super.key,
    required this.selectedProject,
    required this.selectedOperation,
    required this.notifications,
    required this.onProjectChanged,
    required this.onOperationChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onSearchPressed,
    required this.onResetPressed,
    this.isSearchEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 800;

    // Extract unique projects and operations from notifications
    final uniqueProjects = notifications
        .map((n) => n.projectNameA ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();

    final uniqueOperations = notifications
        .map((n) => n.procNameA ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.filterBy,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Filter Fields
          if (isLargeScreen)
            // Desktop Layout - 2 columns
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildProjectDropdown(
                        context,
                        l10n,
                        uniqueProjects,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildOperationDropdown(
                        context,
                        l10n,
                        uniqueOperations,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ResponseStatusFilterRadio(
                        selectedStatus: selectedStatus,
                        onChanged: onStatusChanged,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            )
          else
            // Mobile/Tablet Layout - 1 column
            Column(
              children: [
                _buildProjectDropdown(context, l10n, uniqueProjects),
                const SizedBox(height: 16),
                _buildOperationDropdown(context, l10n, uniqueOperations),
                const SizedBox(height: 16),
                ResponseStatusFilterRadio(
                  selectedStatus: selectedStatus,
                  onChanged: onStatusChanged,
                ),
              ],
            ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: isSearchEnabled ? onSearchPressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.search),
                    label: Text(
                      l10n.search,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: onResetPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: Text(
                      l10n.reset,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDropdown(
    BuildContext context,
    AppLocalizations l10n,
    List<String> projects,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.projectFilter,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedProject,
            decoration: InputDecoration(
              hintText: l10n.selectProject,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF4F46E5)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            items: projects
                .map(
                  (project) => DropdownMenuItem(
                    value: project,
                    child: Text(project, style: const TextStyle(fontSize: 14)),
                  ),
                )
                .toList(),
            onChanged: onProjectChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildOperationDropdown(
    BuildContext context,
    AppLocalizations l10n,
    List<String> operations,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.operationFilter,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedOperation,
            decoration: InputDecoration(
              hintText: l10n.selectOperation,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF4F46E5)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            items: operations
                .map(
                  (operation) => DropdownMenuItem(
                    value: operation,
                    child: Text(
                      operation,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
            onChanged: onOperationChanged,
          ),
        ],
      ),
    );
  }
}

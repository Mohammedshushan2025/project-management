import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/projects_model.dart';
import '../../daily_tasks/widgets/project_filter_dropdown.dart';
import '../../daily_tasks/widgets/contract_number_filter.dart';
import '../../../l10n/app_localizations.dart';

class NotificationFilterSection extends StatelessWidget {
  final String? selectedProject;
  final List<Project> projects;
  final ValueChanged<String?> onProjectChanged;
  final TextEditingController contractController;
  final int? selectedResponseStatus; // null=All, 0=Not Replied, 1=Replied
  final ValueChanged<int?> onResponseStatusChanged;
  final VoidCallback onResetPressed;
  final VoidCallback onSearchPressed;

  const NotificationFilterSection({
    super.key,
    required this.selectedProject,
    required this.projects,
    required this.onProjectChanged,
    required this.contractController,
    required this.selectedResponseStatus,
    required this.onResponseStatusChanged,
    required this.onSearchPressed,
    required this.onResetPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 800;

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ProjectFilterDropdown(
                    selectedProject: selectedProject,
                    projects: projects,
                    onChanged: onProjectChanged,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ContractNumberFilter(controller: contractController),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildResponseStatusDropdown(l10n)),
              ],
            )
          else
            Column(
              children: [
                ProjectFilterDropdown(
                  selectedProject: selectedProject,
                  projects: projects,
                  onChanged: onProjectChanged,
                ),
                const SizedBox(height: 16),
                ContractNumberFilter(controller: contractController),
                const SizedBox(height: 16),
                _buildResponseStatusDropdown(l10n),
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
                    onPressed: onSearchPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  Widget _buildResponseStatusDropdown(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.status,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4F46E5),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int?>(
              value: selectedResponseStatus,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4F46E5)),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.allStatus)),
                DropdownMenuItem(value: 0, child: Text(l10n.notReplied)),
                DropdownMenuItem(value: 1, child: Text(l10n.replied)),
              ],
              onChanged: onResponseStatusChanged,
            ),
          ),
        ),
      ],
    );
  }
}

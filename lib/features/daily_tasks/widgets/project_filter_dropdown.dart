import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/projects_model.dart';
import '../../../../l10n/app_localizations.dart';

class ProjectFilterDropdown extends StatelessWidget {
  final String? selectedProject;
  final List<Project> projects;
  final ValueChanged<String?> onChanged;

  const ProjectFilterDropdown({
    super.key,
    required this.selectedProject,
    required this.projects,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: selectedProject,
        decoration: InputDecoration(
          labelText: l10n.projectFilter,
          hintText: l10n.selectProject,
          prefixIcon: Icon(
            Icons.folder_open,
            color: const Color(0xFF4F46E5),
            size: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        items: projects.map((Project project) {
          return DropdownMenuItem<String>(
            value: project.projectId.toString(),
            child: Text(
              project.nameA ?? '',
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4F46E5)),
        style: TextStyle(color: Colors.grey[800], fontSize: 14),
      ),
    );
  }
}

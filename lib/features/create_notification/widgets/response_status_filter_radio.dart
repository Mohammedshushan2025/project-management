import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

enum ResponseStatus { notReplied, replied, all }

class ResponseStatusFilterRadio extends StatelessWidget {
  final ResponseStatus selectedStatus;
  final ValueChanged<ResponseStatus> onChanged;

  const ResponseStatusFilterRadio({
    super.key,
    required this.selectedStatus,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.responseStatusFilter,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          _buildRadioOption(
            context,
            title: l10n.notReplied,
            value: ResponseStatus.notReplied,
            icon: Icons.pending_outlined,
          ),
          _buildRadioOption(
            context,
            title: l10n.replied,
            value: ResponseStatus.replied,
            icon: Icons.check_circle_outline,
          ),
          _buildRadioOption(
            context,
            title: l10n.allStatus,
            value: ResponseStatus.all,
            icon: Icons.list_alt,
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    BuildContext context, {
    required String title,
    required ResponseStatus value,
    required IconData icon,
  }) {
    final isSelected = selectedStatus == value;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF4F46E5)
                      : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              size: 18,
              color: isSelected ? const Color(0xFF4F46E5) : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? const Color(0xFF4F46E5) : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

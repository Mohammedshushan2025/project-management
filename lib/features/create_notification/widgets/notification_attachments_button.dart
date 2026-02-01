import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class NotificationAttachmentsButton extends StatelessWidget {
  const NotificationAttachmentsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Implement attachments functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.attachmentsButton} - ${l10n.comingSoon}'),
              backgroundColor: const Color(0xFF4F46E5),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        icon: const Icon(Icons.attach_file, size: 24),
        label: Text(
          l10n.attachmentsButton,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

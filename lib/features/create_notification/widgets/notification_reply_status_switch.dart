import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class NotificationReplyStatusSwitch extends StatelessWidget {
  final int? doneFlag;

  const NotificationReplyStatusSwitch({super.key, required this.doneFlag});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isReplied = doneFlag == 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isReplied
              ? [Colors.green[50]!, Colors.green[100]!]
              : [Colors.orange[50]!, Colors.orange[100]!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isReplied ? Colors.green[200]! : Colors.orange[200]!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isReplied ? Colors.green : Colors.orange).withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isReplied ? Colors.green[600] : Colors.orange[600],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isReplied ? Icons.check_circle : Icons.pending,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.replyStatusLabel,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isReplied ? l10n.replied : l10n.notRepliedYet,
                  style: TextStyle(
                    fontSize: 18,
                    color: isReplied ? Colors.green[800] : Colors.orange[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Animated Switch
          Transform.scale(
            scale: 1.2,
            child: Switch(
              value: isReplied,
              onChanged: null, // Read-only
              activeColor: Colors.green[600],
              inactiveThumbColor: Colors.orange[600],
              inactiveTrackColor: Colors.orange[200],
            ),
          ),
        ],
      ),
    );
  }
}

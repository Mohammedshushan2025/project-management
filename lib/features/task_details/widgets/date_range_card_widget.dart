import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeCardWidget extends StatelessWidget {
  final dynamic projectData;
  final bool showArabic;

  const DateRangeCardWidget({
    super.key,
    required this.projectData,
    required this.showArabic,
  });

  String _formatDate(String? dateString, String locale) {
    if (dateString == null || dateString.isEmpty) {
      return '';
    }

    try {
      // Parse the ISO 8601 date string
      final DateTime parsedDate = DateTime.parse(dateString);

      // Format based on locale
      final DateFormat formatter = locale == 'ar'
          ? DateFormat('d MMMM yyyy', 'ar')
          : DateFormat('MMM d, yyyy', 'en');

      return formatter.format(parsedDate);
    } catch (e) {
      // If parsing fails, return the original string
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = showArabic ? 'ar' : 'en';

    // Translation labels
    final fromDateLabel = showArabic ? 'من تاريخ' : 'From Date';
    final toDateLabel = showArabic ? 'إلى تاريخ' : 'To Date';
    final durationLabel = showArabic ? 'المدة' : 'Duration';
    final daysLabel = showArabic ? 'يوم' : 'Days';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF59E0B).withOpacity(0.1),
            Color(0xFFFBBF24).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFF59E0B).withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          fromDateLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(projectData.startDate, locale),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 40, width: 1, color: Colors.grey[300]),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          toDateLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Text(
                        _formatDate(projectData.endDate, locale),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFF59E0B).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timelapse, size: 20, color: Color(0xFFF59E0B)),
                const SizedBox(width: 8),
                Text(
                  '$durationLabel: ${projectData.period ?? 0} $daysLabel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

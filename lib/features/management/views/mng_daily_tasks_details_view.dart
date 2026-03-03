import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../core/models/proccess_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/management_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../task_details/widgets/task_info_card.dart';
import '../../task_details/widgets/employee_dropdown_widget.dart';
import '../../task_details/widgets/notes_input_widget.dart';

class MngDailyTasksDetailsView extends StatefulWidget {
  final Items? taskItem;

  const MngDailyTasksDetailsView({super.key, this.taskItem});

  static const String routeName = 'mng_daily_tasks_details_view';

  @override
  State<MngDailyTasksDetailsView> createState() =>
      _MngDailyTasksDetailsViewState();
}

class _MngDailyTasksDetailsViewState extends State<MngDailyTasksDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    _notesController.text = widget.taskItem?.remarks ?? '';
    _replyController.text = widget.taskItem?.managerRemarks ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final mngProvider = Provider.of<ManagementProvider>(
        context,
        listen: false,
      );
      authProvider.getAllUsers();
      mngProvider.fetchTaskProccess(altKey: widget.taskItem?.altKey ?? '');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _notesController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '--/--/----';

    try {
      DateTime parsedDate;

      if (date.contains(' ')) {
        parsedDate = DateTime.parse(date);
      } else if (date.contains('-')) {
        parsedDate = DateTime.parse(date);
      } else if (date.contains('/')) {
        return date;
      } else {
        return date;
      }

      final day = parsedDate.day.toString().padLeft(2, '0');
      final month = parsedDate.month.toString().padLeft(2, '0');
      final year = parsedDate.year.toString();

      return '$day/$month/$year';
    } catch (e) {
      try {
        final parts = date.split('-');
        if (parts.length >= 3) {
          final year = parts[0];
          final month = parts[1];
          final day = parts[2].split(' ')[0];
          return '$day/$month/$year';
        }
      } catch (_) {}

      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCompleted = widget.taskItem?.doneFlag == 1;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFEC4899)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header Section
                  _buildHeader(context, l10n),

                  // Content Section
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                l10n.taskDetailsTitle,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Section 1: Task Information
                              _buildSectionTitle(
                                context,
                                l10n.taskInformation,
                                Icons.info_outline_rounded,
                              ),
                              const SizedBox(height: 16),

                              // Project and Process Information
                              Consumer<ManagementProvider>(
                                builder: (context, mngProvider, child) {
                                  final processData = mngProvider
                                      .taskProccessModel
                                      ?.items
                                      ?.first;
                                  return TaskInfoCard(
                                    projectNameAr: processData?.nameA,
                                    projectNameEn: processData?.nameE,
                                    processNameAr: processData?.procNameA,
                                    processNameEn: processData?.procNameE,
                                    contractNo: processData?.contractNo
                                        ?.toString(),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),

                              // Employee Dropdown (Read-Only)
                              Consumer<ManagementProvider>(
                                builder: (context, mngProvider, _) {
                                  final processData = mngProvider
                                      .taskProccessModel
                                      ?.items
                                      ?.first;
                                  return Consumer<AuthProvider>(
                                    builder: (context, authProvider, child) {
                                      return AbsorbPointer(
                                        child: EmployeeDropdownWidget(
                                          users: authProvider.allUsers,
                                          defaultEmployeeCode: processData
                                              ?.nextUsersCodeAct
                                              ?.toString(),
                                          selectedEmployeeCode: null,
                                          onChanged: (value) {},
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 16),

                              // Notes Input Fields (Read-Only)
                              AbsorbPointer(
                                child: NotesInputWidget(
                                  notesController: _notesController,
                                  replyController: _replyController,
                                  isReplyReadOnly: true,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Task Status Display (Read-Only)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF4F46E5,
                                      ).withOpacity(0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Status Checkbox
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: isCompleted
                                                ? const Color(
                                                    0xFF10B981,
                                                  ).withOpacity(0.1)
                                                : Colors.grey[100],
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: isCompleted
                                                  ? const Color(0xFF10B981)
                                                  : Colors.grey[300]!,
                                              width: 2,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                isCompleted
                                                    ? Icons.check_circle
                                                    : Icons
                                                          .radio_button_unchecked,
                                                color: isCompleted
                                                    ? const Color(0xFF10B981)
                                                    : Colors.grey[400],
                                                size: 28,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                isCompleted
                                                    ? l10n.taskCompleted
                                                    : l10n.taskNotCompleted,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: isCompleted
                                                      ? const Color(0xFF10B981)
                                                      : Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // Date Display
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF3B82F6,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: const Color(
                                                0xFF3B82F6,
                                              ).withOpacity(0.3),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today_rounded,
                                                color: Color(0xFF3B82F6),
                                                size: 24,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                _formatDate(
                                                  widget.taskItem?.doneDate
                                                      ?.toString(),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF3B82F6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // Title
          Text(
            l10n.taskDetails,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Language Toggle Button
          Consumer<LocaleProvider>(
            builder: (context, provider, child) {
              final isArabic = provider.locale.languageCode == 'ar';
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      final newLang = isArabic ? 'en' : 'ar';
                      provider.setLocale(Locale(newLang));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.language,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isArabic ? 'EN' : 'ع',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import 'package:shehabapp/core/providers/daily_tasks_provider.dart';
import 'package:shehabapp/features/daily_tasks/widgets/status_filter_radio.dart';
import '../../../core/models/project_tasks_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../daily_tasks/widgets/filter_section_widget.dart';
import 'widgets/mng_data_table_widget.dart';

class MngDailyTasksView extends StatefulWidget {
  const MngDailyTasksView({super.key});

  static const String routeName = 'mng_daily_tasks_view';

  @override
  State<MngDailyTasksView> createState() => _MngDailyTasksViewState();
}

class _MngDailyTasksViewState extends State<MngDailyTasksView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _selectedProject;
  final TextEditingController _contractController = TextEditingController();
  final TextEditingController _secController = TextEditingController();
  TaskStatus _selectedStatus = TaskStatus.all;

  List<Items> _tasks = [];
  bool _isLoading = false;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final dailyTasksProvider = Provider.of<DailyTasksProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final usersCode = authProvider.currentUser?.usersCode.toString();

    await dailyTasksProvider.getProjects();
    await dailyTasksProvider.getProjectsDetails(usersCode: usersCode ?? '');

    if (mounted) {
      setState(() {
        _tasks = dailyTasksProvider.projectTasksModel?.items ?? [];
      });
    }
  }

  void _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    final dailyTasksProvider = Provider.of<DailyTasksProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final usersCode = authProvider.currentUser?.usersCode.toString();

    int? doneFlag;
    if (_selectedStatus == TaskStatus.doneOnly) {
      doneFlag = 1;
    } else if (_selectedStatus == TaskStatus.notDoneOnly) {
      doneFlag = 0;
    }

    await dailyTasksProvider.getProjectsDetails(
      usersCode: usersCode ?? '',
      projectId: _selectedProject,
      contractNo: _contractController.text.isNotEmpty
          ? _contractController.text
          : null,
      secNo: _secController.text.isNotEmpty ? _secController.text : null,
      doneFlag: doneFlag,
    );

    if (mounted) {
      setState(() {
        _tasks = dailyTasksProvider.projectTasksModel?.items ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _contractController.dispose();
    _secController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  _buildHeader(context, l10n),
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
                            children: [
                              Text(
                                l10n.dailyTasks,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),

                              const SizedBox(height: 24),

                              Consumer<DailyTasksProvider>(
                                builder: (context, dailyTasksProvider, child) {
                                  final projects =
                                      dailyTasksProvider.projectsModel?.items ??
                                      [];
                                  return FilterSectionWidget(
                                    selectedProject: _selectedProject,
                                    projects: projects,
                                    onProjectChanged: (value) {
                                      setState(() {
                                        _selectedProject = value;
                                        log(
                                          'selectedProject $_selectedProject',
                                        );
                                      });
                                    },
                                    contractController: _contractController,
                                    secController: _secController,
                                    selectedStatus: _selectedStatus,
                                    onStatusChanged: (value) {
                                      setState(() {
                                        _selectedStatus = value;
                                      });
                                    },
                                    onSearchPressed: _performSearch,
                                    onResetPressed: () {
                                      setState(() {
                                        _selectedProject = null;
                                        _contractController.clear();
                                        _secController.clear();
                                        _selectedStatus = TaskStatus.all;
                                      });
                                      _performSearch();
                                    },
                                  );
                                },
                              ),

                              const SizedBox(height: 24),

                              Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFF4F46E5).withOpacity(0.3),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              _isLoading
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CircularProgressIndicator(
                                            color: Color(0xFF4F46E5),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            l10n.loading,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : MngDataTableWidget(tasks: _tasks),
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

          Text(
            l10n.dailyTasks,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

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
}

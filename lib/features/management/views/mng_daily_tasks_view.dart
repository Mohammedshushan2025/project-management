import 'package:flutter/foundation.dart'; // for compute()
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/models/proccess_model.dart';
import 'package:shehabapp/core/models/projects_model.dart';
import 'package:shehabapp/core/providers/management_provider.dart';
import 'package:shehabapp/features/daily_tasks/widgets/status_filter_radio.dart';
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

  late AnimationController _shimmerController;

  // All tasks fetched from API (never filtered in place)
  List<Items> _allTasks = [];

  // Currently displayed tasks after applying filters
  List<Items> _tasks = [];

  // Derived list of unique projects for dropdown
  List<Project> _projects = [];

  // Filter state
  String? _selectedProject;
  final TextEditingController _contractController = TextEditingController();
  final TextEditingController _secController = TextEditingController();
  TaskStatus _selectedStatus = TaskStatus.all;

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

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  /// Fetches all tasks from API then builds the projects dropdown list.
  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);

    try {
      final mngProvider = Provider.of<ManagementProvider>(
        context,
        listen: false,
      );
      await mngProvider.fetchTaskProccessList();

      if (!mounted) return;

      final all = mngProvider.taskProccessListModel?.items ?? [];

      // Offload project extraction to background isolate (avoids UI freeze on large lists)
      final projects = await compute(_extractProjectsIsolate, all);

      if (!mounted) return;
      setState(() {
        _allTasks = all;
        _tasks = all;
        _projects = projects;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء تحميل البيانات: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Applies all active filters on `_allTasks` and updates `_tasks`.
  void _performSearch() {
    setState(() => _isLoading = true);

    final contractText = _contractController.text.trim().toLowerCase();
    final secText = _secController.text.trim().toLowerCase();

    final filtered = _allTasks.where((task) {
      // --- Project filter ---
      if (_selectedProject != null && _selectedProject!.isNotEmpty) {
        if (task.projectId?.toString() != _selectedProject) return false;
      }

      // --- Contract number filter ---
      if (contractText.isNotEmpty) {
        if (!(task.contractNo?.toString().toLowerCase().contains(
              contractText,
            ) ??
            false)) {
          return false;
        }
      }

      // --- Section number filter ---
      if (secText.isNotEmpty) {
        if (!(task.secNo?.toString().toLowerCase().contains(secText) ??
            false)) {
          return false;
        }
      }

      // --- Status filter ---
      if (_selectedStatus == TaskStatus.doneOnly && task.doneFlag != 1) {
        return false;
      }
      if (_selectedStatus == TaskStatus.notDoneOnly && task.doneFlag == 1) {
        return false;
      }

      return true;
    }).toList();

    setState(() {
      _tasks = filtered;
      _isLoading = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedProject = null;
      _contractController.clear();
      _secController.clear();
      _selectedStatus = TaskStatus.all;
      _tasks = _allTasks;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
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

                              // Filter Section
                              FilterSectionWidget(
                                selectedProject: _selectedProject,
                                projects: _projects,
                                onProjectChanged: (value) {
                                  setState(() => _selectedProject = value);
                                },
                                contractController: _contractController,
                                secController: _secController,
                                selectedStatus: _selectedStatus,
                                onStatusChanged: (value) {
                                  setState(() => _selectedStatus = value);
                                },
                                onSearchPressed: _performSearch,
                                onResetPressed: _resetFilters,
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
                                  ? _buildShimmerSkeleton()
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

  Widget _buildShimmerSkeleton() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        // Triangle wave: 0→1→0 ping-pong
        final t = _shimmerController.value;
        final shimmerValue = t < 0.5 ? t * 2 : (1 - t) * 2;
        final opacity = 0.3 + 0.6 * shimmerValue;
        return Column(
          children: List.generate(
            6,
            (index) => _buildShimmerRow(opacity, index),
          ),
        );
      },
    );
  }

  Widget _buildShimmerRow(double opacity, int index) {
    final widths = [0.55, 0.35, 0.45, 0.3, 0.4, 0.25];
    final w = widths[index % widths.length];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circle avatar placeholder
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4F46E5).withOpacity(opacity * 0.18),
            ),
          ),
          const SizedBox(width: 12),
          // Text lines placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 13,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(opacity * 0.35),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 11,
                  width: MediaQuery.of(context).size.width * w,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(opacity * 0.22),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Status badge placeholder
          Container(
            width: 60,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(opacity * 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
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

/// Extracts unique projects from the task list.
/// Must be a top-level function to work with compute() to avoid UI freezing.
List<Project> _extractProjectsIsolate(List<Items> tasks) {
  final seen = <dynamic>{};
  final projects = <Project>[];
  for (final task in tasks) {
    if (task.projectId != null && !seen.contains(task.projectId)) {
      seen.add(task.projectId);
      projects.add(
        Project(
          projectId: task.projectId,
          nameA: task.nameA?.toString(),
          nameE: task.nameE?.toString(),
        ),
      );
    }
  }
  return projects;
}

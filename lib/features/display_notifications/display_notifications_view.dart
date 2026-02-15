import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehabapp/core/providers/auth_provider.dart';
import '../../core/providers/notification_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/providers/locale_provider.dart';
import '../../core/models/create_notification_model.dart';
import 'widgets/notification_data_table_widget.dart';
import 'widgets/notification_filter_section.dart';

class DisplayNotificationsView extends StatefulWidget {
  final int userCode;

  const DisplayNotificationsView({super.key, required this.userCode});

  static const String routeName = 'display_notifications_view';

  @override
  State<DisplayNotificationsView> createState() =>
      _DisplayNotificationsViewState();
}

class _DisplayNotificationsViewState extends State<DisplayNotificationsView>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Filter state
  String? _selectedProject;
  final TextEditingController _contractController = TextEditingController();
  int? _selectedResponseStatus; // null=All, 0=Not Replied, 1=Replied

  // Data state
  List<Items> _notifications = [];
  bool _isLoading = false;

  // Project and Operation names from API
  String? _projectName;
  String? _operationName;

  @override
  void initState() {
    super.initState();

    // Initialize animations
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

    // Load data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() async {
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    try {
      // Load projects first
      print('🔵 Starting to load projects...');
      await notificationProvider.getProjects();
      print('🟢 Projects loaded successfully');
      print(
        '📊 Projects count: ${notificationProvider.projectsModel?.items?.length ?? 0}',
      );

      if (notificationProvider.projectsModel?.items != null) {
        print(
          '📋 First project: ${notificationProvider.projectsModel!.items!.first.nameE}',
        );
      }
    } catch (e) {
      print('🔴 Error loading projects: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تحميل المشاريع: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    try {
      // Then load notifications
      print('🔵 Starting to load notifications...');
      await notificationProvider.getNotificationListByUserCode(
        userCode: widget.userCode,
      );
      print('🟢 Notifications loaded successfully');
    } catch (e) {
      print('🔴 Error loading notifications: $e');
    }

    // Update UI after data is loaded
    if (mounted) {
      setState(() {
        _notifications =
            notificationProvider.NotificationsModelByUserCode?.items ?? [];

        // Extract project and operation names from first notification
        if (_notifications.isNotEmpty) {
          final firstNotification = _notifications.first;
          _projectName = firstNotification.projectNameA;
          _operationName = firstNotification.procNameA;

          print('📋 Project Name: $_projectName');
          print('📋 Operation Name: $_operationName');
        }
      });
    }
  }

  void _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    // Call API with filters
    await notificationProvider.getNotificationListByUserCode(
      userCode: widget.userCode,
      doneFlag: _selectedResponseStatus,
      projectId: _selectedProject,
      contractNo: _contractController.text.isNotEmpty
          ? _contractController.text
          : null,
    );

    // Update UI with filtered data from API
    if (mounted) {
      setState(() {
        _notifications =
            notificationProvider.NotificationsModelByUserCode?.items ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _contractController.dispose();
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
                            children: [
                              // Title
                              Text(
                                l10n.notificationsView,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Filter Section
                              Consumer<NotificationProvider>(
                                builder:
                                    (context, notificationProvider, child) {
                                      final projects =
                                          notificationProvider
                                              .projectsModel
                                              ?.items ??
                                          [];
                                      return NotificationFilterSection(
                                        selectedProject: _selectedProject,
                                        projects: projects,
                                        onProjectChanged: (value) {
                                          setState(() {
                                            _selectedProject = value;
                                          });
                                        },
                                        contractController: _contractController,
                                        selectedResponseStatus:
                                            _selectedResponseStatus,
                                        onResponseStatusChanged: (value) {
                                          setState(() {
                                            _selectedResponseStatus = value;
                                          });
                                        },
                                        onSearchPressed: _performSearch,
                                        onResetPressed: () {
                                          setState(() {
                                            _selectedProject = null;
                                            _contractController.clear();
                                            _selectedResponseStatus = null;
                                          });
                                          _performSearch();
                                        },
                                      );
                                    },
                              ),

                              const SizedBox(height: 24),

                              // Horizontal Divider
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

                              // Data Table
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
                                            l10n.loadingNotifications,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : NotificationDataTableWidget(
                                      notifications: _notifications,
                                    ),

                              const SizedBox(height: 24),
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
            onTap: () async {
              // Refresh counts BEFORE navigating back
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              final usersCode = authProvider.currentUser?.usersCode.toString();

              if (usersCode != null && usersCode.isNotEmpty) {
                await authProvider.getProjectCategoriesCount(
                  usersCode: usersCode,
                );
              }

              // Now navigate back with refreshed data
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
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
            l10n.notificationsView,
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
}

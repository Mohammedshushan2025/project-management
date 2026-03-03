import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/models/task_permission_model.dart';
import '../../../core/providers/management_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../task_permissions/widgets/permission_info_card_widget.dart';
import '../../task_permissions/widgets/permission_filter_widget.dart';
import 'widgets/mng_permission_data_table_widget.dart';

class MngPermissionsView extends StatefulWidget {
  const MngPermissionsView({super.key});

  static const String routeName = 'mng_permissions_view';

  @override
  State<MngPermissionsView> createState() => _MngPermissionsViewState();
}

class _MngPermissionsViewState extends State<MngPermissionsView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  PermissionStatus _selectedStatus = PermissionStatus.all;
  List<Permission> _permissions = [];
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
    setState(() {
      _isLoading = true;
    });

    final managementProvider = Provider.of<ManagementProvider>(
      context,
      listen: false,
    );

    try {
      await managementProvider.fetchPermissions();

      if (mounted) {
        setState(() {
          _permissions = managementProvider.permissionModel?.items ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _performSearch() {
    final managementProvider = Provider.of<ManagementProvider>(
      context,
      listen: false,
    );

    setState(() {
      _isLoading = true;
    });

    String statusFilter = 'all';
    if (_selectedStatus == PermissionStatus.active) {
      statusFilter = 'active';
    } else if (_selectedStatus == PermissionStatus.expired) {
      statusFilter = 'expired';
    }

    final allItems = managementProvider.permissionModel?.items ?? [];
    List<Permission> filteredData = [];

    if (statusFilter == 'all') {
      filteredData = allItems;
    } else {
      final now = DateTime.now();
      filteredData = allItems.where((item) {
        if (item.endDate == null) return false;
        try {
          final endDate = DateTime.parse(item.endDate!);
          if (statusFilter == 'active') {
            return endDate.isAfter(now) || endDate.isAtSameMomentAs(now);
          } else {
            return endDate.isBefore(now);
          }
        } catch (e) {
          return false;
        }
      }).toList();
    }

    setState(() {
      _permissions = filteredData;
      _isLoading = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedStatus = PermissionStatus.all;
    });
    _performSearch();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                                l10n.taskPermissionsTitle,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Consumer<ManagementProvider>(
                                builder: (context, provider, child) {
                                  final items = provider.permissionModel?.items;
                                  final firstPerm =
                                      (items != null && items.isNotEmpty)
                                      ? items.first
                                      : null;
                                  return PermissionInfoCardWidget(
                                    projectNameAr: firstPerm?.projectNameA,
                                    projectNameEn: firstPerm?.projectNameE,
                                    contractNo: firstPerm?.contractNo,
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              PermissionFilterWidget(
                                selectedStatus: _selectedStatus,
                                onStatusChanged: (value) {
                                  setState(() {
                                    _selectedStatus = value;
                                  });
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
                              SizedBox(
                                height: 400,
                                child: _isLoading
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
                                              l10n.loadingPermissions,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : MngPermissionDataTableWidget(
                                        permissions: _permissions,
                                        onDataChanged: _loadInitialData,
                                      ),
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
            l10n.taskPermissions,
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

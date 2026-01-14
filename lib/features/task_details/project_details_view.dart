import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/daily_tasks_provider.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/project_name_header_widget.dart';
import 'widgets/section_title_widget.dart';
import 'widgets/info_card_widget.dart';
import 'widgets/date_range_card_widget.dart';
import 'widgets/team_member_card_widget.dart';
import 'widgets/financial_card_widget.dart';
import 'widgets/loading_state_widget.dart';
import 'widgets/empty_state_widget.dart';

class ProjectDetailsView extends StatefulWidget {
  final String? projectId;

  const ProjectDetailsView({super.key, this.projectId});

  static const String routeName = 'project_details_view';

  @override
  State<ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<ProjectDetailsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Toggle for displaying Arabic or English data
  bool _showArabic = true;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    // Load project details
    if (widget.projectId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<DailyTasksProvider>(
          context,
          listen: false,
        );
        provider.getProjectDetailsModel(projectId: widget.projectId!);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Translation helper method
  String _translate(String arText, String enText) {
    return _showArabic ? arText : enText;
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
          child: Directionality(
            textDirection: _showArabic ? TextDirection.rtl : TextDirection.ltr,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Header
                  _buildHeader(context, l10n),

                  // Content
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
                      child: Consumer<DailyTasksProvider>(
                        builder: (context, provider, _) {
                          if (provider.isLoading) {
                            return const LoadingStateWidget();
                          }

                          if (provider.projectDetailsModel == null ||
                              provider.projectDetailsModel!.items == null ||
                              provider.projectDetailsModel!.items!.isEmpty) {
                            return const EmptyStateWidget();
                          }

                          return SlideTransition(
                            position: _slideAnimation,
                            child: _buildContent(
                              context,
                              l10n,
                              provider.projectDetailsModel!.items!.first,
                            ),
                          );
                        },
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
              child: Icon(
                _showArabic
                    ? Icons.arrow_forward_ios
                    : Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // Title
          Text(
            _translate('تفاصيل المشروع', 'Project Details'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Language Toggle Button
          GestureDetector(
            onTap: () {
              setState(() {
                _showArabic = !_showArabic;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.translate, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    _showArabic ? 'EN' : 'ع',
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
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    dynamic projectData,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Name Header
          ProjectNameHeaderWidget(
            projectData: projectData,
            showArabic: _showArabic,
          ),
          const SizedBox(height: 24),

          // Basic Information Section
          SectionTitleWidget(
            title: _translate('المعلومات الأساسية', 'Basic Information'),
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 16),
          _buildBasicInfoCards(l10n, projectData),
          const SizedBox(height: 24),

          // Project Team Section
          SectionTitleWidget(
            title: _translate('فريق المشروع', 'Project Team'),
            icon: Icons.people_outline,
          ),
          const SizedBox(height: 16),
          _buildTeamCards(l10n, projectData),
          const SizedBox(height: 24),

          // Financial Information
          SectionTitleWidget(
            title: _translate('المعلومات المالية', 'Financial Information'),
            icon: Icons.attach_money_outlined,
          ),
          const SizedBox(height: 16),
          FinancialCardWidget(
            projectData: projectData,
            showArabic: _showArabic,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoCards(AppLocalizations l10n, dynamic projectData) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InfoCardWidget(
                label: _translate('رقم المشروع', 'Project Number'),
                value: projectData.projectId?.toString() ?? '',
                icon: Icons.tag,
                gradientColors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InfoCardWidget(
                label: _translate('رقم أمر العمل', 'Work Order Number'),
                value: projectData.woNo ?? '',
                icon: Icons.description_outlined,
                gradientColors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InfoCardWidget(
                label: _translate('كود العقد', 'Contract Code'),
                value: projectData.contractNo ?? '',
                icon: Icons.receipt_long,
                gradientColors: [Color(0xFFEC4899), Color(0xFFF472B6)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InfoCardWidget(
                label: _translate(
                  'رقم العقد الموحد',
                  'Unified Contract Number',
                ),
                value: projectData.contrSerNo ?? '',
                icon: Icons.numbers,
                gradientColors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InfoCardWidget(
                label: _translate('رقم SEC', 'SEC Number'),
                value: projectData.secNo ?? '',
                icon: Icons.qr_code,
                gradientColors: [Color(0xFF06B6D4), Color(0xFF22D3EE)],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InfoCardWidget(
                label: _translate('حالة المشروع', 'Project Status'),
                value: _showArabic
                    ? (projectData.statusDesc ?? '')
                    : (projectData.statusDescE?.isNotEmpty == true
                          ? projectData.statusDescE!
                          : projectData.statusDesc ?? ''),
                icon: Icons.timeline,
                gradientColors: [Color(0xFF10B981), Color(0xFF34D399)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        DateRangeCardWidget(projectData: projectData, showArabic: _showArabic),
      ],
    );
  }

  Widget _buildTeamCards(AppLocalizations l10n, dynamic projectData) {
    return Column(
      children: [
        TeamMemberCardWidget(
          label: _translate('مهندس المشروع', 'Project Engineer'),
          name: _showArabic
              ? (projectData.engName ?? '')
              : (projectData.engNameE?.isNotEmpty == true
                    ? projectData.engNameE!
                    : projectData.engName ?? ''),
          icon: Icons.engineering,
          gradientColors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
        ),
        const SizedBox(height: 12),
        TeamMemberCardWidget(
          label: _translate('مدير المشروع', 'Project Manager'),
          name: _showArabic
              ? (projectData.pManagerName ?? '')
              : (projectData.pManagerNameE?.isNotEmpty == true
                    ? projectData.pManagerNameE!
                    : projectData.pManagerName ?? ''),
          icon: Icons.manage_accounts,
          gradientColors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        ),
        const SizedBox(height: 12),
        TeamMemberCardWidget(
          label: _translate('مدير المشاريع', 'Projects Manager'),
          name: _showArabic
              ? (projectData.poManagerName ?? '')
              : (projectData.poManagerNameE?.isNotEmpty == true
                    ? projectData.poManagerNameE!
                    : projectData.poManagerName ?? ''),
          icon: Icons.supervisor_account,
          gradientColors: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ),
        const SizedBox(height: 12),
        TeamMemberCardWidget(
          label: _translate('العميل', 'Client'),
          name: _showArabic
              ? (projectData.customerName ?? '')
              : (projectData.customerNameE?.isNotEmpty == true
                    ? projectData.customerNameE!
                    : projectData.customerName ?? ''),
          icon: Icons.business,
          gradientColors: [Color(0xFF10B981), Color(0xFF34D399)],
        ),
        const SizedBox(height: 12),
        TeamMemberCardWidget(
          label: _translate('جهة الإسناد', 'Assignment Authority'),
          name: _showArabic
              ? (projectData.accDesc ?? '')
              : (projectData.accDescE?.isNotEmpty == true
                    ? projectData.accDescE!
                    : projectData.accDesc ?? ''),
          icon: Icons.account_balance,
          gradientColors: [Color(0xFF06B6D4), Color(0xFF22D3EE)],
        ),
        const SizedBox(height: 12),
        TeamMemberCardWidget(
          label: _translate('جهة الإشراف', 'Supervision Authority'),
          name: _showArabic
              ? (projectData.supervisionDesc ?? '')
              : (projectData.supervisionDescE?.isNotEmpty == true
                    ? projectData.supervisionDescE!
                    : projectData.supervisionDesc ?? ''),
          icon: Icons.admin_panel_settings,
          gradientColors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        ),
      ],
    );
  }
}

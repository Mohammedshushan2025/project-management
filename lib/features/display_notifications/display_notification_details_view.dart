import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/providers/notification_provider.dart';
import '../../core/providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../core/models/create_notification_model.dart';
import 'widgets/notification_details_header.dart';
import 'widgets/notification_info_card.dart';
import 'widgets/notification_attachments_button.dart';

class DisplayNotificationDetailsView extends StatefulWidget {
  final int userCode;
  final String altKey;
  final int projectId;
  final int partId;
  final int flowId;
  final int procId;
  final int noteSer;

  const DisplayNotificationDetailsView({
    super.key,
    required this.userCode,
    required this.altKey,
    required this.projectId,
    required this.partId,
    required this.flowId,
    required this.procId,
    required this.noteSer,
  });

  static const String routeName = 'notification_details_view';

  @override
  State<DisplayNotificationDetailsView> createState() =>
      _DisplayNotificationDetailsViewState();
}

class _DisplayNotificationDetailsViewState
    extends State<DisplayNotificationDetailsView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Items? _notificationDetails;

  // Reply section state
  bool _isDoneFlag = false;
  String? _doneDate;
  final TextEditingController _replyDescController = TextEditingController();
  bool _isSaving = false;

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

    // Load notification details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotificationDetails();
    });
  }

  void _loadNotificationDetails() async {
    final notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    await notificationProvider.getNotificationDetailsByUserCode(
      userCode: widget.userCode,
      altKey: widget.altKey,
    );

    if (mounted) {
      setState(() {
        _notificationDetails =
            notificationProvider.NotificationsModelByUserCode?.items?.first;

        // Initialize reply state
        if (_notificationDetails != null) {
          _isDoneFlag = _notificationDetails!.doneFlag == 1;
          _doneDate = _notificationDetails!.doneDate;
          _replyDescController.text = _notificationDetails!.reDesc ?? '';
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _replyDescController.dispose();
    super.dispose();
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final localeProvider = Provider.of<LocaleProvider>(
        context,
        listen: false,
      );
      final isArabic = localeProvider.locale.languageCode == 'ar';

      if (isArabic) {
        return DateFormat('dd MMMM yyyy', 'ar').format(date);
      } else {
        return DateFormat('dd MMMM yyyy', 'en').format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> _handleSaveReply() async {
    final l10n = AppLocalizations.of(context)!;

    // Validate reply description
    if (_isDoneFlag && _replyDescController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[700], size: 28),
              const SizedBox(width: 12),
              Text(
                l10n.error,
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'يجب كتابة وصف الرد قبل تفعيل "تم الرد"',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.ok,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );

      await notificationProvider.updateDoneFlag(
        altKey: widget.altKey,
        doneFlag: 1,
        doneDate: DateTime.now().toString(),
        reDesc: _replyDescController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(l10n.savedSuccessfully),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Reload notification details
        _loadNotificationDetails();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في الحفظ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _getLocalizedText(String? arabicText, dynamic englishText) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    if (isArabic) {
      return arabicText ?? '';
    } else {
      if (englishText == null) return arabicText ?? '';
      return englishText.toString();
    }
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
                  // Header
                  const NotificationDetailsHeader(),

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
                      child: Consumer<NotificationProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return _buildLoadingState(l10n);
                          }

                          if (_notificationDetails == null) {
                            return _buildErrorState(l10n);
                          }

                          return _buildContent(context, l10n);
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

  Widget _buildLoadingState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFF4F46E5)),
          const SizedBox(height: 16),
          Text(
            l10n.loadingNotificationDetails,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            l10n.noDataAvailable,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            l10n.notificationDetailsTitle,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),

          const SizedBox(height: 24),

          // Project
          NotificationInfoCard(
            label: l10n.project,
            value: _getLocalizedText(
              _notificationDetails?.projectNameA,
              _notificationDetails?.projectNameE,
            ),
            icon: Icons.business,
          ),

          const SizedBox(height: 16),

          // Operation
          NotificationInfoCard(
            label: l10n.operation,
            value: _getLocalizedText(
              _notificationDetails?.procNameA,
              _notificationDetails?.procNameE,
            ),
            icon: Icons.settings,
          ),

          const SizedBox(height: 16),

          // User Type
          NotificationInfoCard(
            label: l10n.userType,
            value: _getLocalizedText(
              _notificationDetails?.userTypeName,
              _notificationDetails?.userTypeNameE,
            ),
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 16),

          // User Name
          NotificationInfoCard(
            label: l10n.userName,
            value: _getLocalizedText(
              _notificationDetails?.usersName,
              _notificationDetails?.usersNameE,
            ),
            icon: Icons.person,
          ),

          const SizedBox(height: 16),

          // Notification Type
          NotificationInfoCard(
            label: l10n.notificationTypeLabel,
            value: _getLocalizedText(
              _notificationDetails?.noteTypeName,
              _notificationDetails?.noteTypeNameE,
            ),
            icon: Icons.notifications_active,
          ),

          const SizedBox(height: 16),

          // Notification Date
          NotificationInfoCard(
            label: l10n.notificationDateLabel,
            value: _formatDate(_notificationDetails?.noteDate),
            icon: Icons.calendar_today,
          ),

          const SizedBox(height: 16),

          // Description
          NotificationInfoCard(
            label: l10n.description,
            value: _getLocalizedText(
              _notificationDetails?.descA,
              _notificationDetails?.descE,
            ),
            icon: Icons.description,
            isLongText: true,
          ),

          const SizedBox(height: 24),

          // Reply Section Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.reply, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.replySection,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F46E5),
                ),
              ),
              // // Show "Read Only" badge if already replied
              // if (_notificationDetails?.doneFlag == 1) ...[
              //   const SizedBox(width: 12),
              //   Container(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 12,
              //       vertical: 6,
              //     ),
              //     decoration: BoxDecoration(
              //       color: Colors.orange[100],
              //       borderRadius: BorderRadius.circular(20),
              //       border: Border.all(color: Colors.orange[300]!),
              //     ),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       children: [
              //         Icon(Icons.lock, size: 14, color: Colors.orange[700]),
              //         const SizedBox(width: 4),
              //         Text(
              //           'للعرض فقط',
              //           style: TextStyle(
              //             fontSize: 12,
              //             fontWeight: FontWeight.w600,
              //             color: Colors.orange[700],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ],
            ],
          ),

          const SizedBox(height: 16),

          // Reply Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Done Flag Switch - Creative Design
                GestureDetector(
                  onTap: _notificationDetails?.doneFlag == 1
                      ? null
                      : () {
                          setState(() {
                            _isDoneFlag = !_isDoneFlag;
                            if (_isDoneFlag) {
                              _doneDate = DateTime.now().toIso8601String();
                            } else {
                              _doneDate = null;
                            }
                          });
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: _isDoneFlag
                          ? LinearGradient(
                              colors: [Colors.green[400]!, Colors.green[600]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : LinearGradient(
                              colors: [Colors.grey[300]!, Colors.grey[400]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _isDoneFlag
                              ? Colors.green.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Icon
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _isDoneFlag
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isDoneFlag ? 'تم الرد ✓' : 'لم يتم الرد',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isDoneFlag
                                    ? 'تم حفظ الرد بنجاح'
                                    : 'اضغط للتفعيل',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Toggle Indicator
                        if (_notificationDetails?.doneFlag != 1)
                          AnimatedRotation(
                            turns: _isDoneFlag ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.toggle_on,
                              color: Colors.white,
                              size: 40,
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Reply Date (shown when switch is on)
                if (_isDoneFlag && _doneDate != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.replyDate,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(_doneDate),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                // Reply Description TextField
                const SizedBox(height: 16),
                Text(
                  l10n.replyDescription,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _replyDescController,
                  maxLines: 4,
                  readOnly:
                      _notificationDetails?.doneFlag ==
                      1, // Read-only if already replied
                  enabled:
                      _notificationDetails?.doneFlag !=
                      1, // Disable if already replied
                  decoration: InputDecoration(
                    hintText: _notificationDetails?.doneFlag == 1
                        ? 'تم حفظ الرد'
                        : 'اكتب وصف الرد هنا...',
                    filled: true,
                    fillColor: _notificationDetails?.doneFlag == 1
                        ? Colors.grey[200]
                        : Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF4F46E5),
                        width: 2,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  style: TextStyle(
                    color: _notificationDetails?.doneFlag == 1
                        ? Colors.grey[700]
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Save Button - Only show if not already replied
          if (_notificationDetails?.doneFlag != 1) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSaveReply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF4F46E5).withOpacity(0.4),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.save, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            l10n.save,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Insert User
          NotificationInfoCard(
            label: l10n.insertUserLabel,
            value: _notificationDetails?.insertUser?.toString() ?? '',
            icon: Icons.person_add,
          ),

          const SizedBox(height: 32),

          // Attachments Button
          NotificationAttachmentsButton(
            projectId: widget.projectId,
            partId: widget.partId,
            flowId: widget.flowId,
            procId: widget.procId,
            noteSer: widget.noteSer,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

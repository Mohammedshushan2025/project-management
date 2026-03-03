import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/create_notification_model.dart';
import 'package:shehabapp/core/models/mng_notif_cnt_model.dart';
import 'package:shehabapp/core/models/mng_permit_cnt_model.dart';
import 'package:shehabapp/core/models/mng_proc_cnt_model.dart';
import 'package:shehabapp/core/models/proccess_model.dart';
import 'package:shehabapp/core/models/task_permission_model.dart';
import 'package:shehabapp/core/services/management_service.dart';

class ManagementProvider extends ChangeNotifier {
  final ManagementService _managementService = ManagementService();

  MngNotifCntModel? _notificationCountModel;
  MngPermitCntModel? _permitCountModel;
  MngProcCntModel? _procCountModel;
  CreateNotificationModel? _notificationListModel;
  CreateNotificationModel? _notificationDetailsModel;
  PermissionModel? _permissionModel;
  PermissionModel? _permissionDetailsModel;
  ProccessModel? _taskProccessModel;

  MngNotifCntModel? get notificationCountModel => _notificationCountModel;
  MngPermitCntModel? get permitCountModel => _permitCountModel;
  MngProcCntModel? get procCountModel => _procCountModel;
  CreateNotificationModel? get notificationListModel => _notificationListModel;
  CreateNotificationModel? get notificationDetailsModel =>
      _notificationDetailsModel;
  PermissionModel? get permissionModel => _permissionModel;
  PermissionModel? get permissionDetailsModel => _permissionDetailsModel;
  ProccessModel? get taskProccessModel => _taskProccessModel;

  Future<void> fetchNotificationCount() async {
    try {
      _notificationCountModel = await _managementService.getNotificationCount();
      notifyListeners();
    } catch (e) {
      print('Error fetching notification count: $e');
    }
  }

  Future<void> fetchPermitCount() async {
    try {
      _permitCountModel = await _managementService.getPermitCount();
      notifyListeners();
    } catch (e) {
      print('Error fetching permit count: $e');
    }
  }

  Future<void> fetchProcCount() async {
    try {
      _procCountModel = await _managementService.getProcCount();
      notifyListeners();
    } catch (e) {
      print('Error fetching proc count: $e');
    }
  }

  Future<void> fetchAllCounts() async {
    await Future.wait([
      fetchNotificationCount(),
      fetchPermitCount(),
      fetchProcCount(),
    ]);
  }

  Future<void> fetchNotificationList() async {
    try {
      _notificationListModel = await _managementService.getNotificationList();
      notifyListeners();
    } catch (e) {
      print('Error fetching notification list: $e');
    }
  }

  Future<void> fetchNotificationDetails({required String altKey}) async {
    try {
      _notificationDetailsModel = await _managementService
          .getNotificationDetails(altKey: altKey);
      notifyListeners();
    } catch (e) {
      print('Error fetching notification details: $e');
    }
  }

  Future<void> fetchPermissions() async {
    try {
      _permissionModel = await _managementService.getPermissions();
      notifyListeners();
    } catch (e) {
      print('Error fetching permissions: $e');
    }
  }

  Future<void> fetchPermissionDetails({required String altKey}) async {
    try {
      _permissionDetailsModel = await _managementService.getPermissionDetails(
        altKey: altKey,
      );
      notifyListeners();
    } catch (e) {
      print('Error fetching permission details: $e');
    }
  }

  Future<void> fetchTaskProccess({required String altKey}) async {
    try {
      _taskProccessModel = await _managementService.getTaskProccess(
        altKey: altKey,
      );
      notifyListeners();
    } catch (e) {
      print('Error fetching task proccess: $e');
    }
  }
}

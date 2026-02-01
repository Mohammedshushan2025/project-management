import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/create_notification_model.dart';
import 'package:shehabapp/core/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  CreateNotificationModel? NotificationsModel;
  CreateNotificationModel? NotificationDetailsModel;
  String? errMessage;
  bool isLoading = false;

  Future<void> getNotificationList({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    int? doneFlag,
  }) async {
    final notificationService = NotificationService();
    isLoading = true;
    errMessage = null;
    notifyListeners();

    try {
      NotificationsModel = await notificationService.getNotificationList(
        projectId: projectId,
        partId: partId,
        flowId: flowId,
        procId: procId,
        doneFlag: doneFlag,
      );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log(
        '💥 Exception in getNotificationList: $e',
        name: 'getNotificationList',
      );
      isLoading = false;
      errMessage = 'An error occurred while fetching notification list: $e';
      notifyListeners();
      throw Exception('An error occurred while fetching notification list: $e');
    }
  }

  Future<void> getNotificationDetails({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
  }) async {
    final notificationService = NotificationService();
    isLoading = true;
    errMessage = null;
    notifyListeners();

    try {
      NotificationDetailsModel = await notificationService
          .getNotificationDetails(
            projectId: projectId,
            partId: partId,
            flowId: flowId,
            procId: procId,
            noteSer: noteSer,
          );
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      log(
        '💥 Exception in getNotificationDetails: $e',
        name: 'getNotificationDetails',
      );
      isLoading = false;
      errMessage = 'An error occurred while fetching notification details: $e';
      notifyListeners();
      throw Exception(
        'An error occurred while fetching notification details: $e',
      );
    }
  }
}

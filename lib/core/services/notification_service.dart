import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shehabapp/core/models/create_notification_model.dart';

class NotificationService {
  Future<CreateNotificationModel> getNotificationList({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    int? doneFlag,
  }) async {
    try {
      String url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsPartsProcNotifVO1?q=ProjectId=$projectId;PartId=$partId;FlowId=$flowId;ProcId=$procId';

      // Add doneFlag to query if provided
      if (doneFlag != null) {
        url += ';DoneFlag=$doneFlag';
      }

      // طباعة بيانات الـ Request
      print('🔵 ========== Notification Request ==========');
      print('📤 URL: $url');
      print('📤 ProjectId: $projectId');
      print('📤 PartId: $partId');
      print('📤 FlowId: $flowId');
      print('📤 ProcId: $procId');
      print('📤 DoneFlag: $doneFlag');
      print('🔵 ==========================================');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);

        // طباعة بيانات الـ Response
        print('🟢 ========== Notification Response ==========');
        print('📥 Status Code: ${response.statusCode}');
        print('📥 Response Data: $jsonData');
        if (jsonData['items'] != null && jsonData['items'].isNotEmpty) {
          print('📥 First Item: ${jsonData['items'][0]}');
          print('📥 Total Items: ${jsonData['items'].length}');
        }
        print('🟢 ============================================');

        return CreateNotificationModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load permission details - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load permission details: $e');
    }
  }

  Future<CreateNotificationModel> getNotificationDetails({
    required int projectId,
    required int partId,
    required int flowId,
    required int procId,
    required int noteSer,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsPartsProcNotifVO1?q=ProjectId=$projectId;PartId=$partId;FlowId=$flowId;ProcId=$procId;NoteSer=$noteSer';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(decodedBody);
        return CreateNotificationModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load notification details - Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load notification details: $e');
    }
  }
}

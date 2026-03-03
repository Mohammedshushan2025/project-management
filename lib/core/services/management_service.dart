import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shehabapp/core/models/create_notification_model.dart';
import 'package:shehabapp/core/models/mng_notif_cnt_model.dart';
import 'package:shehabapp/core/models/mng_permit_cnt_model.dart';
import 'package:shehabapp/core/models/mng_proc_cnt_model.dart';
import 'package:shehabapp/core/models/proccess_model.dart';
import 'package:shehabapp/core/models/task_permission_model.dart';

class ManagementService {
  Future<MngNotifCntModel> getNotificationCount() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExProjectsNotifCnt1';
      log('🌐 API Request URL: $url', name: 'getNotificationCount');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        // log(
        //   '✅ API Response (getProjects): $responseBody',
        //   name: 'DailyTasksService',
        // );

        final MngNotifCntModel notificationCountModel =
            MngNotifCntModel.fromJson(json.decode(responseBody));
        return notificationCountModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getNotificationCount',
        );
        throw Exception('Failed to load notification count data.');
      }
    } catch (e) {
      log(
        '💥 Exception in getNotificationCount: $e',
        name: 'getNotificationCount',
      );
      throw Exception(
        'An error occurred while fetching notification count: $e',
      );
    }
  }

  Future<MngPermitCntModel> getPermitCount() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExProjectsPermitCnt1';
      log('🌐 API Request URL: $url', name: 'getPermitCount');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        // log(
        //   '✅ API Response (getProjects): $responseBody',
        //   name: 'DailyTasksService',
        // );

        final MngPermitCntModel permitModel = MngPermitCntModel.fromJson(
          json.decode(responseBody),
        );
        return permitModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getPermitCount',
        );
        throw Exception('Failed to load permit count data.');
      }
    } catch (e) {
      log('💥 Exception in getPermitCount: $e', name: 'getPermitCount');
      throw Exception('An error occurred while fetching permit count: $e');
    }
  }

  Future<MngProcCntModel> getProcCount() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ExProjectsProcCnt1';
      log('🌐 API Request URL: $url', name: 'getProcCount');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        // log(
        //   '✅ API Response (getProjects): $responseBody',
        //   name: 'DailyTasksService',
        // );

        final MngProcCntModel procModel = MngProcCntModel.fromJson(
          json.decode(responseBody),
        );
        return procModel;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'getProcCount',
        );
        throw Exception('Failed to load proc count data.');
      }
    } catch (e) {
      log('💥 Exception in getProcCount: $e', name: 'getProcCount');
      throw Exception('An error occurred while fetching proc count: $e');
    }
  }

  Future<CreateNotificationModel> getNotificationList() async {
    try {
      String url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsPartsProcNotifVO1';

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
    required String altKey,
  }) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/ProjectsPartsProcNotifVO1?q=AltKey=$altKey';
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

  Future<PermissionModel> getPermissions() async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/EXProjectsPermitsVo1';
      log('🔵 Request URL: $url', name: 'TaskPermissionService');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          // هذا الهيدر يطلب من السيرفر الرد بـ UTF-8، لكن أحياناً السيرفر يتجاهله
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'TaskPermissionService',
      );
      // للتأكد في اللوج، سنطبع النص بعد فك التشفير
      // log('🔵 Response Body: ${response.body}', name: 'TaskPermissionService'); // ❌ القديم

      if (response.statusCode == 200) {
        // ✅ الحل هنا: فك التشفير يدوياً من الـ Bytes
        String decodedBody = utf8.decode(response.bodyBytes);
        log(
          '🔵 Response Body (Decoded): $decodedBody',
          name: 'TaskPermissionService',
        ); // ستظهر العربي صح هنا

        final jsonData = jsonDecode(decodedBody);

        log('✅ Successfully parsed JSON data', name: 'TaskPermissionService');
        return PermissionModel.fromJson(jsonData);
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'TaskPermissionService',
        );
        throw Exception(
          'Failed to load permission details - Status: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'TaskPermissionService');
      log('💥 Stack trace: $stackTrace', name: 'TaskPermissionService');
      throw Exception('Failed to load permission details: $e');
    }
  }

  Future<PermissionModel> getPermissionDetails({required String altKey}) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/EXProjectsPermitsVo1?q=AltKey=$altKey';
      log('🔵 Request URL: $url', name: 'MNG getPermissionDetails');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          // هذا الهيدر يطلب من السيرفر الرد بـ UTF-8، لكن أحياناً السيرفر يتجاهله
          "Content-Type":
              "application/vnd.oracle.adf.resourceitem+json; charset=UTF-8",
        },
      );

      log(
        '🔵 Response Status Code: ${response.statusCode}',
        name: 'MNG getPermissionDetails',
      );
      // للتأكد في اللوج، سنطبع النص بعد فك التشفير
      // log('🔵 Response Body: ${response.body}', name: 'TaskPermissionService'); // ❌ القديم

      if (response.statusCode == 200) {
        // ✅ الحل هنا: فك التشفير يدوياً من الـ Bytes
        String decodedBody = utf8.decode(response.bodyBytes);
        log(
          '🔵 Response Body (Decoded): $decodedBody',
          name: 'MNG getPermissionDetails',
        ); // ستظهر العربي صح هنا

        final jsonData = jsonDecode(decodedBody);

        log(
          '✅ Successfully parsed JSON data',
          name: 'MNG getPermissionDetails',
        );
        return PermissionModel.fromJson(jsonData);
      } else {
        log(
          '❌ Failed with status code: ${response.statusCode}',
          name: 'MNG getPermissionDetails',
        );
        throw Exception(
          'Failed to load permission details - Status: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      log('💥 Exception occurred: $e', name: 'MNG getPermissionDetails');
      log('💥 Stack trace: $stackTrace', name: 'MNG getPermissionDetails');
      throw Exception('Failed to load permission details: $e');
    }
  }

  Future<ProccessModel> getTaskProccess({required String altKey}) async {
    try {
      final url =
          'http://168.119.35.125:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/EXProjectsPartsProcVO2';
      log('🌐 API Request URL: $url', name: 'MNG getTaskProccess');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        // log(
        //   '✅ API Response (getTaskProccess): $responseBody',
        //   name: 'getTaskProccess',
        // );

        final ProccessModel taskProccess = ProccessModel.fromJson(
          json.decode(responseBody),
        );
        return taskProccess;
      } else {
        log(
          '❌ API Error (${response.statusCode}): ${response.body}',
          name: 'MNG getTaskProccess',
        );
        throw Exception('Failed to load task proccess data.');
      }
    } catch (e) {
      log('💥 Exception in getTaskProccess: $e', name: 'MNG getTaskProccess');
      throw Exception('An error occurred while fetching task proccess: $e');
    }
  }
}

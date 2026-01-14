import 'package:flutter/material.dart';
import 'package:shehabapp/core/models/check_see_project_model.dart';
import 'package:shehabapp/core/models/proccess_model.dart';
import 'package:shehabapp/core/models/project_details_model.dart';
import 'package:shehabapp/core/models/project_tasks_model.dart';
import 'package:shehabapp/core/models/projects_model.dart';
import 'package:shehabapp/core/models/task_details_model.dart';
import 'package:shehabapp/core/services/daily_tasks_service.dart';

class DailyTasksProvider with ChangeNotifier {
  final DailyTasksService _dailyTasksService = DailyTasksService();
  ProjectsModel? projectsModel;
  ProjectTasksModel? projectTasksModel;
  TaskDetailsModel? taskDetailsModel;
  ProccessModel? taskProccessModel;
  ProjectDetailsModel? projectDetailsModel;
  CheckSeeProjectModel? checkSeeProjectModel;
  bool isLoading = false;
  String? errorMessage;

  Future<void> getProjects() async {
    isLoading = true;
    notifyListeners();
    try {
      projectsModel = await _dailyTasksService.getProjects();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProjectsDetails({
    required String usersCode,
    String? projectId,
    String? contractNo,
    String? secNo,
    int? doneFlag,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      projectTasksModel = await _dailyTasksService.getProjectsDetails(
        usersCode: usersCode,
        projectId: projectId,
        contractNo: contractNo,
        secNo: secNo,
        doneFlag: doneFlag,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkExecuteStatus({required String altKey}) async {
    isLoading = true;
    notifyListeners();
    try {
      taskDetailsModel = await _dailyTasksService.checkExecuteStatus(
        altKey: altKey,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTaskProccess({required String altKey}) async {
    isLoading = true;
    notifyListeners();
    try {
      taskProccessModel = await _dailyTasksService.getTaskProccess(
        altKey: altKey,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTaskProccess({
    required String altKey,
    required String remarks,
    required String nextUsersCode,
    required String doneFlag,
    required String doneDate,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      await _dailyTasksService.UpdateTaskProccessData(
        altKey: altKey,
        remarks: remarks,
        nextUsersCode: nextUsersCode,
        doneFlag: doneFlag,
        doneDate: doneDate,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProjectDetailsModel({required String projectId}) async {
    isLoading = true;
    notifyListeners();
    try {
      projectDetailsModel = await _dailyTasksService.getProjectDetailsModel(
        projectId: projectId,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkSeeProject({required String usersCode}) async {
    isLoading = true;
    notifyListeners();
    try {
      checkSeeProjectModel = await _dailyTasksService.checkSeeProject(
        usersCode: usersCode,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}

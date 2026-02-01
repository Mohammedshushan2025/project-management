class CreateNotificationModel {
  List<Items>? items;

  CreateNotificationModel({this.items});

  CreateNotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? partId;
  int? flowId;
  int? procId;
  int? noteSer;
  int? userType;
  String? userTypeName;
  String? userTypeNameE;
  int? userCode;
  String? usersName;
  dynamic usersNameE;
  int? noteType;
  String? noteTypeName;
  String? noteTypeNameE;
  String? descA;
  dynamic descE;
  String? noteDate;
  int? doneFlag;
  String? doneDate;
  String? reDesc;
  int? projectId;
  dynamic altKey;
  dynamic insertUser;
  String? projectNameA;
  dynamic projectNameE;
  dynamic secNo;
  String? contractNo;
  String? procNameA;
  String? procNameE;
  List<Links>? links;

  Items({
    this.partId,
    this.flowId,
    this.procId,
    this.noteSer,
    this.userType,
    this.userTypeName,
    this.userTypeNameE,
    this.userCode,
    this.usersName,
    this.usersNameE,
    this.noteType,
    this.noteTypeName,
    this.noteTypeNameE,
    this.descA,
    this.descE,
    this.noteDate,
    this.doneFlag,
    this.doneDate,
    this.reDesc,
    this.projectId,
    this.altKey,
    this.insertUser,
    this.projectNameA,
    this.projectNameE,
    this.secNo,
    this.contractNo,
    this.procNameA,
    this.procNameE,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    partId = json['PartId'];
    flowId = json['FlowId'];
    procId = json['ProcId'];
    noteSer = json['NoteSer'];
    userType = json['UserType'];
    userTypeName = json['UserTypeName'];
    userTypeNameE = json['UserTypeNameE'];
    userCode = json['UserCode'];
    usersName = json['UsersName'];
    usersNameE = json['UsersNameE'];
    noteType = json['NoteType'];
    noteTypeName = json['NoteTypeName'];
    noteTypeNameE = json['NoteTypeNameE'];
    descA = json['DescA'];
    descE = json['DescE'];
    noteDate = json['NoteDate'];
    doneFlag = json['DoneFlag'];
    doneDate = json['DoneDate'];
    reDesc = json['ReDesc'];
    projectId = json['ProjectId'];
    altKey = json['AltKey'];
    insertUser = json['InsertUser'];
    projectNameA = json['ProjectNameA'];
    projectNameE = json['ProjectNameE'];
    secNo = json['SecNo'];
    contractNo = json['ContractNo'];
    procNameA = json['ProcNameA'];
    procNameE = json['ProcNameE'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PartId'] = this.partId;
    data['FlowId'] = this.flowId;
    data['ProcId'] = this.procId;
    data['NoteSer'] = this.noteSer;
    data['UserType'] = this.userType;
    data['UserTypeName'] = this.userTypeName;
    data['UserTypeNameE'] = this.userTypeNameE;
    data['UserCode'] = this.userCode;
    data['UsersName'] = this.usersName;
    data['UsersNameE'] = this.usersNameE;
    data['NoteType'] = this.noteType;
    data['NoteTypeName'] = this.noteTypeName;
    data['NoteTypeNameE'] = this.noteTypeNameE;
    data['DescA'] = this.descA;
    data['DescE'] = this.descE;
    data['NoteDate'] = this.noteDate;
    data['DoneFlag'] = this.doneFlag;
    data['DoneDate'] = this.doneDate;
    data['ReDesc'] = this.reDesc;
    data['ProjectId'] = this.projectId;
    data['AltKey'] = this.altKey;
    data['InsertUser'] = this.insertUser;
    data['ProjectNameA'] = this.projectNameA;
    data['ProjectNameE'] = this.projectNameE;
    data['SecNo'] = this.secNo;
    data['ContractNo'] = this.contractNo;
    data['ProcNameA'] = this.procNameA;
    data['ProcNameE'] = this.procNameE;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Links {
  String? rel;

  Links({this.rel});

  Links.fromJson(Map<String, dynamic> json) {
    rel = json['rel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rel'] = this.rel;
    return data;
  }
}

class ProjectDetailsModel {
  List<Items>? items;
  int? count;
  bool? hasMore;
  int? limit;
  int? offset;
  List<Links>? links;

  ProjectDetailsModel({
    this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    this.links,
  });

  ProjectDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    count = json['count'];
    hasMore = json['hasMore'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['hasMore'] = this.hasMore;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? projectId;
  String? nameA;
  Null? nameE;
  String? startDate;
  int? projectLifeTime;
  String? endDate;
  int? projectValue;
  Null? paymentMethod;
  Null? tenderId;
  Null? mnTypeCode;
  Null? sectorCode;
  Null? accountNo;
  Null? costCenter1;
  Null? costCenter2;
  int? status;
  int? paymentSchedule;
  Null? firstPaymentDate;
  Null? laborCost;
  Null? assetsCost;
  Null? consumablesCost;
  Null? otherIndirectCost;
  Null? profitMargin;
  Null? prjctInitValue;
  Null? prjctInitFDate;
  Null? prjctInitTDate;
  Null? prjctFinalValue;
  Null? prjctFinalFDate;
  Null? prjctFinalTDate;
  Null? prjctInitFDateH;
  Null? prjctInitTDateH;
  Null? prjctFinalFDateH;
  Null? prjctFinalTDateH;
  int? storeCode;
  int? accreditationCode;
  Null? projectNumber;
  int? supervisionCode;
  int? customerCode;
  int? initialProjectValue;
  Null? rInitValue;
  Null? projectComplete;
  Null? projectStoped;
  Null? stopedReasonA;
  Null? stopedReasonE;
  Null? activityId;
  Null? executeId;
  Null? ownerCompanyNumber;
  Null? projectStatus;
  Null? trnsferDate;
  Null? projectCode;
  Null? contractDate;
  Null? intDeliveryDate;
  Null? finlDeliveryDate;
  Null? prePayAcc;
  Null? resrvGrntAcc;
  Null? bankAcc;
  Null? incomeProjAcc;
  Null? expProjAcc;
  Null? ownerAcc;
  Null? finalProjDate;
  Null? finalProjPeriod;
  Null? closeFlag;
  Null? recPayFlag;
  Null? allDuePayed;
  Null? endRecvFlag;
  Null? closeDate;
  Null? endExDate;
  Null? recvdValDate;
  Null? closePjUser;
  Null? reopenUser;
  Null? countryId;
  Null? regionId;
  Null? compareExpAcc;
  Null? consultantName;
  Null? projVal;
  Null? bankCode;
  Null? branchCode;
  Null? empCode;
  Null? compEmpCode;
  Null? engCompEmpCode;
  Null? engEmpCode;
  Null? engEmpName;
  Null? engEmpName2;
  Null? engMobil2;
  Null? engMobil;
  Null? lgCode;
  Null? remarks;
  Null? accountMan;
  Null? accountMobile;
  int? companyCode;
  int? dCode;
  Null? discPrcn;
  Null? stopedDate;
  Null? tTaxFlag1;
  Null? taxValue1;
  int? projectManager;
  int? projectManagerEmp;
  Null? taxCode1;
  Null? taxCode2;
  Null? taxValue2;
  Null? tTaxFlag2;
  Null? overheadCost;
  Null? overheadPrc;
  Null? overheadFlag;
  Null? exProfitVal;
  Null? exProfitPrc;
  Null? exProfitFlag;
  Null? discVal;
  Null? discFlag;
  int? poManager;
  int? poManagerEmp;
  Null? lcCostVal;
  Null? lcCostPrc;
  Null? lcCostFlag;
  int? ownerId;
  Null? awardedNo;
  Null? awardedDate;
  int? lgLetterFlag;
  Null? projectPlanning;
  Null? projectPlanningDays;
  Null? projectBandPlanning;
  Null? projectBandPlanningDays;
  Null? locationDlvrDate;
  int? startFlag;
  int? totalProjectValue;
  int? oldProjectValue;
  int? advValue;
  int? advPrc;
  int? rsrvValue;
  int? rsrvPrc;
  Null? ddctValue;
  Null? ddctBackValue;
  int? disc1Value;
  int? disc1Prc;
  int? disc2Value;
  int? disc2Prc;
  int? disc3Value;
  int? disc3Prc;
  int? disc4Value;
  int? disc4Prc;
  Null? disc5Value;
  Null? disc5Prc;
  int? oldAdvValue;
  int? oldRsrvValue;
  int? oldDdctValue;
  int? oldDdctBackValue;
  int? oldDisc1Value;
  int? oldDisc2Value;
  int? oldDisc3Value;
  int? oldDisc4Value;
  Null? oldDisc5Value;
  int? deptNo;
  String? startDateH;
  String? endDateH;
  Null? locationDlvrDateH;
  Null? awardedDateH;
  String? contractNo;
  Null? contractDateH;
  int? contractProjectValue;
  String? contrSerNo;
  int? contractSerial;
  int? exStartPay;
  int? taxStartVal;
  int? taxStartPay;
  Null? exInsuBank;
  Null? exInsuMid;
  Null? exInsuCode;
  int? openPostFlag;
  Null? openEntryYear;
  Null? openEntryType;
  Null? openEntryNo;
  Null? openArTrnsId;
  Null? openArTrnsSerial;
  Null? openArMainareaId;
  Null? openArSubareaId;
  int? closePostFlag;
  Null? closeEntryYear;
  Null? closeEntryType;
  Null? closeEntryNo;
  Null? closeArTrnsId;
  Null? closeArTrnsSerial;
  Null? closeArMainareaId;
  Null? closeArSubareaId;
  int? projectLifeTimeType;
  Null? insuNo;
  Null? insuDateH;
  Null? insuDate;
  Null? openPayMethod;
  Null? closePayMethod;
  Null? openDate;
  Null? closeDate2;
  Null? materialReservationNo;
  String? woNo;
  int? detAnalysisFlag;
  Null? secNo;
  int? period;
  String? statusDesc;
  String? statusDescE;
  String? accDesc;
  String? accDescE;
  String? supervisionDesc;
  Null? supervisionDescE;
  String? customerName;
  Null? customerNameE;
  Null? engName;
  Null? engNameE;
  String? pManagerName;
  String? pManagerNameE;
  String? poManagerName;
  String? poManagerNameE;
  List<Links>? links;

  Items({
    this.projectId,
    this.nameA,
    this.nameE,
    this.startDate,
    this.projectLifeTime,
    this.endDate,
    this.projectValue,
    this.paymentMethod,
    this.tenderId,
    this.mnTypeCode,
    this.sectorCode,
    this.accountNo,
    this.costCenter1,
    this.costCenter2,
    this.status,
    this.paymentSchedule,
    this.firstPaymentDate,
    this.laborCost,
    this.assetsCost,
    this.consumablesCost,
    this.otherIndirectCost,
    this.profitMargin,
    this.prjctInitValue,
    this.prjctInitFDate,
    this.prjctInitTDate,
    this.prjctFinalValue,
    this.prjctFinalFDate,
    this.prjctFinalTDate,
    this.prjctInitFDateH,
    this.prjctInitTDateH,
    this.prjctFinalFDateH,
    this.prjctFinalTDateH,
    this.storeCode,
    this.accreditationCode,
    this.projectNumber,
    this.supervisionCode,
    this.customerCode,
    this.initialProjectValue,
    this.rInitValue,
    this.projectComplete,
    this.projectStoped,
    this.stopedReasonA,
    this.stopedReasonE,
    this.activityId,
    this.executeId,
    this.ownerCompanyNumber,
    this.projectStatus,
    this.trnsferDate,
    this.projectCode,
    this.contractDate,
    this.intDeliveryDate,
    this.finlDeliveryDate,
    this.prePayAcc,
    this.resrvGrntAcc,
    this.bankAcc,
    this.incomeProjAcc,
    this.expProjAcc,
    this.ownerAcc,
    this.finalProjDate,
    this.finalProjPeriod,
    this.closeFlag,
    this.recPayFlag,
    this.allDuePayed,
    this.endRecvFlag,
    this.closeDate,
    this.endExDate,
    this.recvdValDate,
    this.closePjUser,
    this.reopenUser,
    this.countryId,
    this.regionId,
    this.compareExpAcc,
    this.consultantName,
    this.projVal,
    this.bankCode,
    this.branchCode,
    this.empCode,
    this.compEmpCode,
    this.engCompEmpCode,
    this.engEmpCode,
    this.engEmpName,
    this.engEmpName2,
    this.engMobil2,
    this.engMobil,
    this.lgCode,
    this.remarks,
    this.accountMan,
    this.accountMobile,
    this.companyCode,
    this.dCode,
    this.discPrcn,
    this.stopedDate,
    this.tTaxFlag1,
    this.taxValue1,
    this.projectManager,
    this.projectManagerEmp,
    this.taxCode1,
    this.taxCode2,
    this.taxValue2,
    this.tTaxFlag2,
    this.overheadCost,
    this.overheadPrc,
    this.overheadFlag,
    this.exProfitVal,
    this.exProfitPrc,
    this.exProfitFlag,
    this.discVal,
    this.discFlag,
    this.poManager,
    this.poManagerEmp,
    this.lcCostVal,
    this.lcCostPrc,
    this.lcCostFlag,
    this.ownerId,
    this.awardedNo,
    this.awardedDate,
    this.lgLetterFlag,
    this.projectPlanning,
    this.projectPlanningDays,
    this.projectBandPlanning,
    this.projectBandPlanningDays,
    this.locationDlvrDate,
    this.startFlag,
    this.totalProjectValue,
    this.oldProjectValue,
    this.advValue,
    this.advPrc,
    this.rsrvValue,
    this.rsrvPrc,
    this.ddctValue,
    this.ddctBackValue,
    this.disc1Value,
    this.disc1Prc,
    this.disc2Value,
    this.disc2Prc,
    this.disc3Value,
    this.disc3Prc,
    this.disc4Value,
    this.disc4Prc,
    this.disc5Value,
    this.disc5Prc,
    this.oldAdvValue,
    this.oldRsrvValue,
    this.oldDdctValue,
    this.oldDdctBackValue,
    this.oldDisc1Value,
    this.oldDisc2Value,
    this.oldDisc3Value,
    this.oldDisc4Value,
    this.oldDisc5Value,
    this.deptNo,
    this.startDateH,
    this.endDateH,
    this.locationDlvrDateH,
    this.awardedDateH,
    this.contractNo,
    this.contractDateH,
    this.contractProjectValue,
    this.contrSerNo,
    this.contractSerial,
    this.exStartPay,
    this.taxStartVal,
    this.taxStartPay,
    this.exInsuBank,
    this.exInsuMid,
    this.exInsuCode,
    this.openPostFlag,
    this.openEntryYear,
    this.openEntryType,
    this.openEntryNo,
    this.openArTrnsId,
    this.openArTrnsSerial,
    this.openArMainareaId,
    this.openArSubareaId,
    this.closePostFlag,
    this.closeEntryYear,
    this.closeEntryType,
    this.closeEntryNo,
    this.closeArTrnsId,
    this.closeArTrnsSerial,
    this.closeArMainareaId,
    this.closeArSubareaId,
    this.projectLifeTimeType,
    this.insuNo,
    this.insuDateH,
    this.insuDate,
    this.openPayMethod,
    this.closePayMethod,
    this.openDate,
    this.closeDate2,
    this.materialReservationNo,
    this.woNo,
    this.detAnalysisFlag,
    this.secNo,
    this.period,
    this.statusDesc,
    this.statusDescE,
    this.accDesc,
    this.accDescE,
    this.supervisionDesc,
    this.supervisionDescE,
    this.customerName,
    this.customerNameE,
    this.engName,
    this.engNameE,
    this.pManagerName,
    this.pManagerNameE,
    this.poManagerName,
    this.poManagerNameE,
    this.links,
  });

  Items.fromJson(Map<String, dynamic> json) {
    projectId = json['ProjectId'];
    nameA = json['NameA'];
    nameE = json['NameE'];
    startDate = json['StartDate'];
    projectLifeTime = json['ProjectLifeTime'];
    endDate = json['EndDate'];
    projectValue = json['ProjectValue'];
    paymentMethod = json['PaymentMethod'];
    tenderId = json['TenderId'];
    mnTypeCode = json['MnTypeCode'];
    sectorCode = json['SectorCode'];
    accountNo = json['AccountNo'];
    costCenter1 = json['CostCenter1'];
    costCenter2 = json['CostCenter2'];
    status = json['Status'];
    paymentSchedule = json['PaymentSchedule'];
    firstPaymentDate = json['FirstPaymentDate'];
    laborCost = json['LaborCost'];
    assetsCost = json['AssetsCost'];
    consumablesCost = json['ConsumablesCost'];
    otherIndirectCost = json['OtherIndirectCost'];
    profitMargin = json['ProfitMargin'];
    prjctInitValue = json['PrjctInitValue'];
    prjctInitFDate = json['PrjctInitFDate'];
    prjctInitTDate = json['PrjctInitTDate'];
    prjctFinalValue = json['PrjctFinalValue'];
    prjctFinalFDate = json['PrjctFinalFDate'];
    prjctFinalTDate = json['PrjctFinalTDate'];
    prjctInitFDateH = json['PrjctInitFDateH'];
    prjctInitTDateH = json['PrjctInitTDateH'];
    prjctFinalFDateH = json['PrjctFinalFDateH'];
    prjctFinalTDateH = json['PrjctFinalTDateH'];
    storeCode = json['StoreCode'];
    accreditationCode = json['AccreditationCode'];
    projectNumber = json['ProjectNumber'];
    supervisionCode = json['SupervisionCode'];
    customerCode = json['CustomerCode'];
    initialProjectValue = json['InitialProjectValue'];
    rInitValue = json['RInitValue'];
    projectComplete = json['ProjectComplete'];
    projectStoped = json['ProjectStoped'];
    stopedReasonA = json['StopedReasonA'];
    stopedReasonE = json['StopedReasonE'];
    activityId = json['ActivityId'];
    executeId = json['ExecuteId'];
    ownerCompanyNumber = json['OwnerCompanyNumber'];
    projectStatus = json['ProjectStatus'];
    trnsferDate = json['TrnsferDate'];
    projectCode = json['ProjectCode'];
    contractDate = json['ContractDate'];
    intDeliveryDate = json['IntDeliveryDate'];
    finlDeliveryDate = json['FinlDeliveryDate'];
    prePayAcc = json['PrePayAcc'];
    resrvGrntAcc = json['ResrvGrntAcc'];
    bankAcc = json['BankAcc'];
    incomeProjAcc = json['IncomeProjAcc'];
    expProjAcc = json['ExpProjAcc'];
    ownerAcc = json['OwnerAcc'];
    finalProjDate = json['FinalProjDate'];
    finalProjPeriod = json['FinalProjPeriod'];
    closeFlag = json['CloseFlag'];
    recPayFlag = json['RecPayFlag'];
    allDuePayed = json['AllDuePayed'];
    endRecvFlag = json['EndRecvFlag'];
    closeDate = json['CloseDate'];
    endExDate = json['EndExDate'];
    recvdValDate = json['RecvdValDate'];
    closePjUser = json['ClosePjUser'];
    reopenUser = json['ReopenUser'];
    countryId = json['CountryId'];
    regionId = json['RegionId'];
    compareExpAcc = json['CompareExpAcc'];
    consultantName = json['ConsultantName'];
    projVal = json['ProjVal'];
    bankCode = json['BankCode'];
    branchCode = json['BranchCode'];
    empCode = json['EmpCode'];
    compEmpCode = json['CompEmpCode'];
    engCompEmpCode = json['EngCompEmpCode'];
    engEmpCode = json['EngEmpCode'];
    engEmpName = json['EngEmpName'];
    engEmpName2 = json['EngEmpName2'];
    engMobil2 = json['EngMobil2'];
    engMobil = json['EngMobil'];
    lgCode = json['LgCode'];
    remarks = json['Remarks'];
    accountMan = json['AccountMan'];
    accountMobile = json['AccountMobile'];
    companyCode = json['CompanyCode'];
    dCode = json['DCode'];
    discPrcn = json['DiscPrcn'];
    stopedDate = json['StopedDate'];
    tTaxFlag1 = json['TTaxFlag1'];
    taxValue1 = json['TaxValue1'];
    projectManager = json['ProjectManager'];
    projectManagerEmp = json['ProjectManagerEmp'];
    taxCode1 = json['TaxCode1'];
    taxCode2 = json['TaxCode2'];
    taxValue2 = json['TaxValue2'];
    tTaxFlag2 = json['TTaxFlag2'];
    overheadCost = json['OverheadCost'];
    overheadPrc = json['OverheadPrc'];
    overheadFlag = json['OverheadFlag'];
    exProfitVal = json['ExProfitVal'];
    exProfitPrc = json['ExProfitPrc'];
    exProfitFlag = json['ExProfitFlag'];
    discVal = json['DiscVal'];
    discFlag = json['DiscFlag'];
    poManager = json['PoManager'];
    poManagerEmp = json['PoManagerEmp'];
    lcCostVal = json['LcCostVal'];
    lcCostPrc = json['LcCostPrc'];
    lcCostFlag = json['LcCostFlag'];
    ownerId = json['OwnerId'];
    awardedNo = json['AwardedNo'];
    awardedDate = json['AwardedDate'];
    lgLetterFlag = json['LgLetterFlag'];
    projectPlanning = json['ProjectPlanning'];
    projectPlanningDays = json['ProjectPlanningDays'];
    projectBandPlanning = json['ProjectBandPlanning'];
    projectBandPlanningDays = json['ProjectBandPlanningDays'];
    locationDlvrDate = json['LocationDlvrDate'];
    startFlag = json['StartFlag'];
    totalProjectValue = json['TotalProjectValue'];
    oldProjectValue = json['OldProjectValue'];
    advValue = json['AdvValue'];
    advPrc = json['AdvPrc'];
    rsrvValue = json['RsrvValue'];
    rsrvPrc = json['RsrvPrc'];
    ddctValue = json['DdctValue'];
    ddctBackValue = json['DdctBackValue'];
    disc1Value = json['Disc1Value'];
    disc1Prc = json['Disc1Prc'];
    disc2Value = json['Disc2Value'];
    disc2Prc = json['Disc2Prc'];
    disc3Value = json['Disc3Value'];
    disc3Prc = json['Disc3Prc'];
    disc4Value = json['Disc4Value'];
    disc4Prc = json['Disc4Prc'];
    disc5Value = json['Disc5Value'];
    disc5Prc = json['Disc5Prc'];
    oldAdvValue = json['OldAdvValue'];
    oldRsrvValue = json['OldRsrvValue'];
    oldDdctValue = json['OldDdctValue'];
    oldDdctBackValue = json['OldDdctBackValue'];
    oldDisc1Value = json['OldDisc1Value'];
    oldDisc2Value = json['OldDisc2Value'];
    oldDisc3Value = json['OldDisc3Value'];
    oldDisc4Value = json['OldDisc4Value'];
    oldDisc5Value = json['OldDisc5Value'];
    deptNo = json['DeptNo'];
    startDateH = json['StartDateH'];
    endDateH = json['EndDateH'];
    locationDlvrDateH = json['LocationDlvrDateH'];
    awardedDateH = json['AwardedDateH'];
    contractNo = json['ContractNo'];
    contractDateH = json['ContractDateH'];
    contractProjectValue = json['ContractProjectValue'];
    contrSerNo = json['ContrSerNo'];
    contractSerial = json['ContractSerial'];
    exStartPay = json['ExStartPay'];
    taxStartVal = json['TaxStartVal'];
    taxStartPay = json['TaxStartPay'];
    exInsuBank = json['ExInsuBank'];
    exInsuMid = json['ExInsuMid'];
    exInsuCode = json['ExInsuCode'];
    openPostFlag = json['OpenPostFlag'];
    openEntryYear = json['OpenEntryYear'];
    openEntryType = json['OpenEntryType'];
    openEntryNo = json['OpenEntryNo'];
    openArTrnsId = json['OpenArTrnsId'];
    openArTrnsSerial = json['OpenArTrnsSerial'];
    openArMainareaId = json['OpenArMainareaId'];
    openArSubareaId = json['OpenArSubareaId'];
    closePostFlag = json['ClosePostFlag'];
    closeEntryYear = json['CloseEntryYear'];
    closeEntryType = json['CloseEntryType'];
    closeEntryNo = json['CloseEntryNo'];
    closeArTrnsId = json['CloseArTrnsId'];
    closeArTrnsSerial = json['CloseArTrnsSerial'];
    closeArMainareaId = json['CloseArMainareaId'];
    closeArSubareaId = json['CloseArSubareaId'];
    projectLifeTimeType = json['ProjectLifeTimeType'];
    insuNo = json['InsuNo'];
    insuDateH = json['InsuDateH'];
    insuDate = json['InsuDate'];
    openPayMethod = json['OpenPayMethod'];
    closePayMethod = json['ClosePayMethod'];
    openDate = json['OpenDate'];
    closeDate2 = json['CloseDate2'];
    materialReservationNo = json['MaterialReservationNo'];
    woNo = json['WoNo'];
    detAnalysisFlag = json['DetAnalysisFlag'];
    secNo = json['SecNo'];
    period = json['Period'];
    statusDesc = json['StatusDesc'];
    statusDescE = json['StatusDescE'];
    accDesc = json['AccDesc'];
    accDescE = json['AccDescE'];
    supervisionDesc = json['SupervisionDesc'];
    supervisionDescE = json['SupervisionDescE'];
    customerName = json['CustomerName'];
    customerNameE = json['CustomerNameE'];
    engName = json['EngName'];
    engNameE = json['EngNameE'];
    pManagerName = json['PManagerName'];
    pManagerNameE = json['PManagerNameE'];
    poManagerName = json['PoManagerName'];
    poManagerNameE = json['PoManagerNameE'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProjectId'] = this.projectId;
    data['NameA'] = this.nameA;
    data['NameE'] = this.nameE;
    data['StartDate'] = this.startDate;
    data['ProjectLifeTime'] = this.projectLifeTime;
    data['EndDate'] = this.endDate;
    data['ProjectValue'] = this.projectValue;
    data['PaymentMethod'] = this.paymentMethod;
    data['TenderId'] = this.tenderId;
    data['MnTypeCode'] = this.mnTypeCode;
    data['SectorCode'] = this.sectorCode;
    data['AccountNo'] = this.accountNo;
    data['CostCenter1'] = this.costCenter1;
    data['CostCenter2'] = this.costCenter2;
    data['Status'] = this.status;
    data['PaymentSchedule'] = this.paymentSchedule;
    data['FirstPaymentDate'] = this.firstPaymentDate;
    data['LaborCost'] = this.laborCost;
    data['AssetsCost'] = this.assetsCost;
    data['ConsumablesCost'] = this.consumablesCost;
    data['OtherIndirectCost'] = this.otherIndirectCost;
    data['ProfitMargin'] = this.profitMargin;
    data['PrjctInitValue'] = this.prjctInitValue;
    data['PrjctInitFDate'] = this.prjctInitFDate;
    data['PrjctInitTDate'] = this.prjctInitTDate;
    data['PrjctFinalValue'] = this.prjctFinalValue;
    data['PrjctFinalFDate'] = this.prjctFinalFDate;
    data['PrjctFinalTDate'] = this.prjctFinalTDate;
    data['PrjctInitFDateH'] = this.prjctInitFDateH;
    data['PrjctInitTDateH'] = this.prjctInitTDateH;
    data['PrjctFinalFDateH'] = this.prjctFinalFDateH;
    data['PrjctFinalTDateH'] = this.prjctFinalTDateH;
    data['StoreCode'] = this.storeCode;
    data['AccreditationCode'] = this.accreditationCode;
    data['ProjectNumber'] = this.projectNumber;
    data['SupervisionCode'] = this.supervisionCode;
    data['CustomerCode'] = this.customerCode;
    data['InitialProjectValue'] = this.initialProjectValue;
    data['RInitValue'] = this.rInitValue;
    data['ProjectComplete'] = this.projectComplete;
    data['ProjectStoped'] = this.projectStoped;
    data['StopedReasonA'] = this.stopedReasonA;
    data['StopedReasonE'] = this.stopedReasonE;
    data['ActivityId'] = this.activityId;
    data['ExecuteId'] = this.executeId;
    data['OwnerCompanyNumber'] = this.ownerCompanyNumber;
    data['ProjectStatus'] = this.projectStatus;
    data['TrnsferDate'] = this.trnsferDate;
    data['ProjectCode'] = this.projectCode;
    data['ContractDate'] = this.contractDate;
    data['IntDeliveryDate'] = this.intDeliveryDate;
    data['FinlDeliveryDate'] = this.finlDeliveryDate;
    data['PrePayAcc'] = this.prePayAcc;
    data['ResrvGrntAcc'] = this.resrvGrntAcc;
    data['BankAcc'] = this.bankAcc;
    data['IncomeProjAcc'] = this.incomeProjAcc;
    data['ExpProjAcc'] = this.expProjAcc;
    data['OwnerAcc'] = this.ownerAcc;
    data['FinalProjDate'] = this.finalProjDate;
    data['FinalProjPeriod'] = this.finalProjPeriod;
    data['CloseFlag'] = this.closeFlag;
    data['RecPayFlag'] = this.recPayFlag;
    data['AllDuePayed'] = this.allDuePayed;
    data['EndRecvFlag'] = this.endRecvFlag;
    data['CloseDate'] = this.closeDate;
    data['EndExDate'] = this.endExDate;
    data['RecvdValDate'] = this.recvdValDate;
    data['ClosePjUser'] = this.closePjUser;
    data['ReopenUser'] = this.reopenUser;
    data['CountryId'] = this.countryId;
    data['RegionId'] = this.regionId;
    data['CompareExpAcc'] = this.compareExpAcc;
    data['ConsultantName'] = this.consultantName;
    data['ProjVal'] = this.projVal;
    data['BankCode'] = this.bankCode;
    data['BranchCode'] = this.branchCode;
    data['EmpCode'] = this.empCode;
    data['CompEmpCode'] = this.compEmpCode;
    data['EngCompEmpCode'] = this.engCompEmpCode;
    data['EngEmpCode'] = this.engEmpCode;
    data['EngEmpName'] = this.engEmpName;
    data['EngEmpName2'] = this.engEmpName2;
    data['EngMobil2'] = this.engMobil2;
    data['EngMobil'] = this.engMobil;
    data['LgCode'] = this.lgCode;
    data['Remarks'] = this.remarks;
    data['AccountMan'] = this.accountMan;
    data['AccountMobile'] = this.accountMobile;
    data['CompanyCode'] = this.companyCode;
    data['DCode'] = this.dCode;
    data['DiscPrcn'] = this.discPrcn;
    data['StopedDate'] = this.stopedDate;
    data['TTaxFlag1'] = this.tTaxFlag1;
    data['TaxValue1'] = this.taxValue1;
    data['ProjectManager'] = this.projectManager;
    data['ProjectManagerEmp'] = this.projectManagerEmp;
    data['TaxCode1'] = this.taxCode1;
    data['TaxCode2'] = this.taxCode2;
    data['TaxValue2'] = this.taxValue2;
    data['TTaxFlag2'] = this.tTaxFlag2;
    data['OverheadCost'] = this.overheadCost;
    data['OverheadPrc'] = this.overheadPrc;
    data['OverheadFlag'] = this.overheadFlag;
    data['ExProfitVal'] = this.exProfitVal;
    data['ExProfitPrc'] = this.exProfitPrc;
    data['ExProfitFlag'] = this.exProfitFlag;
    data['DiscVal'] = this.discVal;
    data['DiscFlag'] = this.discFlag;
    data['PoManager'] = this.poManager;
    data['PoManagerEmp'] = this.poManagerEmp;
    data['LcCostVal'] = this.lcCostVal;
    data['LcCostPrc'] = this.lcCostPrc;
    data['LcCostFlag'] = this.lcCostFlag;
    data['OwnerId'] = this.ownerId;
    data['AwardedNo'] = this.awardedNo;
    data['AwardedDate'] = this.awardedDate;
    data['LgLetterFlag'] = this.lgLetterFlag;
    data['ProjectPlanning'] = this.projectPlanning;
    data['ProjectPlanningDays'] = this.projectPlanningDays;
    data['ProjectBandPlanning'] = this.projectBandPlanning;
    data['ProjectBandPlanningDays'] = this.projectBandPlanningDays;
    data['LocationDlvrDate'] = this.locationDlvrDate;
    data['StartFlag'] = this.startFlag;
    data['TotalProjectValue'] = this.totalProjectValue;
    data['OldProjectValue'] = this.oldProjectValue;
    data['AdvValue'] = this.advValue;
    data['AdvPrc'] = this.advPrc;
    data['RsrvValue'] = this.rsrvValue;
    data['RsrvPrc'] = this.rsrvPrc;
    data['DdctValue'] = this.ddctValue;
    data['DdctBackValue'] = this.ddctBackValue;
    data['Disc1Value'] = this.disc1Value;
    data['Disc1Prc'] = this.disc1Prc;
    data['Disc2Value'] = this.disc2Value;
    data['Disc2Prc'] = this.disc2Prc;
    data['Disc3Value'] = this.disc3Value;
    data['Disc3Prc'] = this.disc3Prc;
    data['Disc4Value'] = this.disc4Value;
    data['Disc4Prc'] = this.disc4Prc;
    data['Disc5Value'] = this.disc5Value;
    data['Disc5Prc'] = this.disc5Prc;
    data['OldAdvValue'] = this.oldAdvValue;
    data['OldRsrvValue'] = this.oldRsrvValue;
    data['OldDdctValue'] = this.oldDdctValue;
    data['OldDdctBackValue'] = this.oldDdctBackValue;
    data['OldDisc1Value'] = this.oldDisc1Value;
    data['OldDisc2Value'] = this.oldDisc2Value;
    data['OldDisc3Value'] = this.oldDisc3Value;
    data['OldDisc4Value'] = this.oldDisc4Value;
    data['OldDisc5Value'] = this.oldDisc5Value;
    data['DeptNo'] = this.deptNo;
    data['StartDateH'] = this.startDateH;
    data['EndDateH'] = this.endDateH;
    data['LocationDlvrDateH'] = this.locationDlvrDateH;
    data['AwardedDateH'] = this.awardedDateH;
    data['ContractNo'] = this.contractNo;
    data['ContractDateH'] = this.contractDateH;
    data['ContractProjectValue'] = this.contractProjectValue;
    data['ContrSerNo'] = this.contrSerNo;
    data['ContractSerial'] = this.contractSerial;
    data['ExStartPay'] = this.exStartPay;
    data['TaxStartVal'] = this.taxStartVal;
    data['TaxStartPay'] = this.taxStartPay;
    data['ExInsuBank'] = this.exInsuBank;
    data['ExInsuMid'] = this.exInsuMid;
    data['ExInsuCode'] = this.exInsuCode;
    data['OpenPostFlag'] = this.openPostFlag;
    data['OpenEntryYear'] = this.openEntryYear;
    data['OpenEntryType'] = this.openEntryType;
    data['OpenEntryNo'] = this.openEntryNo;
    data['OpenArTrnsId'] = this.openArTrnsId;
    data['OpenArTrnsSerial'] = this.openArTrnsSerial;
    data['OpenArMainareaId'] = this.openArMainareaId;
    data['OpenArSubareaId'] = this.openArSubareaId;
    data['ClosePostFlag'] = this.closePostFlag;
    data['CloseEntryYear'] = this.closeEntryYear;
    data['CloseEntryType'] = this.closeEntryType;
    data['CloseEntryNo'] = this.closeEntryNo;
    data['CloseArTrnsId'] = this.closeArTrnsId;
    data['CloseArTrnsSerial'] = this.closeArTrnsSerial;
    data['CloseArMainareaId'] = this.closeArMainareaId;
    data['CloseArSubareaId'] = this.closeArSubareaId;
    data['ProjectLifeTimeType'] = this.projectLifeTimeType;
    data['InsuNo'] = this.insuNo;
    data['InsuDateH'] = this.insuDateH;
    data['InsuDate'] = this.insuDate;
    data['OpenPayMethod'] = this.openPayMethod;
    data['ClosePayMethod'] = this.closePayMethod;
    data['OpenDate'] = this.openDate;
    data['CloseDate2'] = this.closeDate2;
    data['MaterialReservationNo'] = this.materialReservationNo;
    data['WoNo'] = this.woNo;
    data['DetAnalysisFlag'] = this.detAnalysisFlag;
    data['SecNo'] = this.secNo;
    data['Period'] = this.period;
    data['StatusDesc'] = this.statusDesc;
    data['StatusDescE'] = this.statusDescE;
    data['AccDesc'] = this.accDesc;
    data['AccDescE'] = this.accDescE;
    data['SupervisionDesc'] = this.supervisionDesc;
    data['SupervisionDescE'] = this.supervisionDescE;
    data['CustomerName'] = this.customerName;
    data['CustomerNameE'] = this.customerNameE;
    data['EngName'] = this.engName;
    data['EngNameE'] = this.engNameE;
    data['PManagerName'] = this.pManagerName;
    data['PManagerNameE'] = this.pManagerNameE;
    data['PoManagerName'] = this.poManagerName;
    data['PoManagerNameE'] = this.poManagerNameE;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Links {
  String? rel;
  String? href;
  String? name;
  String? kind;

  Links({this.rel, this.href, this.name, this.kind});

  Links.fromJson(Map<String, dynamic> json) {
    rel = json['rel'];
    href = json['href'];
    name = json['name'];
    kind = json['kind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rel'] = this.rel;
    data['href'] = this.href;
    data['name'] = this.name;
    data['kind'] = this.kind;
    return data;
  }
}

class ReportModel {
  int id;
  String unitName;
  int remainingVaccineCount;
  int unitNeeds;
  String reportDate;

  ReportModel(
      {this.id,
      this.unitName,
      this.remainingVaccineCount,
      this.unitNeeds,
      this.reportDate});

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
        id: json["Id"],
        unitName: json["Unit_Name"],
        remainingVaccineCount: int.parse(json["Remaining_Vaccine_Count"]),
        unitNeeds: int.parse(json["Unit_Needs"]),
        reportDate: json["Report_Date"]);
  }
}

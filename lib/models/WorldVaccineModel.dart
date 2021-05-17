class WorldVaccineModel {
  String ministaryCountry;
  double totalVaccineCount;

  WorldVaccineModel({this.ministaryCountry, this.totalVaccineCount});

  factory WorldVaccineModel.fromJson(Map<String, dynamic> json) {
    return WorldVaccineModel(
        ministaryCountry: json["Ministary_Country"],
        totalVaccineCount: double.parse(json["Total_Vaccine_Count"]));
  }
}

class ClaimModel {
  int id;
  int ministaryId;
  int vaccineCount;
  String date;
  String ministaryCountry;

  ClaimModel(
      {this.id,
      this.ministaryId,
      this.vaccineCount,
      this.date,
      this.ministaryCountry});

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
      id: json["Id"],
      ministaryId: json["Ministary_Id"],
      vaccineCount: int.parse(json["Vaccine_Count"]),
      date: json["Date"],
      ministaryCountry: json["Ministary_Country"],
    );
  }
}

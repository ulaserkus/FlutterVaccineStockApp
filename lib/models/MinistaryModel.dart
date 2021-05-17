class MinistaryModel {
  int id;
  String ministaryCountry;
  int ministaryNeeds;
  String lastPurchaseDate;
  int lastPurchasedVaccineCount;
  int totalVaccineCount;
  String imageUrl;

  MinistaryModel(
      {this.id,
      this.ministaryCountry,
      this.ministaryNeeds,
      this.lastPurchaseDate,
      this.lastPurchasedVaccineCount,
      this.totalVaccineCount,
      this.imageUrl});

  factory MinistaryModel.fromJson(Map<String, dynamic> json) {
    return MinistaryModel(
        id: json["Id"],
        ministaryCountry: json["Ministary_Country"],
        ministaryNeeds: int.parse(json["Ministary_Needs"]),
        lastPurchaseDate: json["Last_Purchase_Date"],
        lastPurchasedVaccineCount:
            int.parse(json["Last_Purchased_Vaccine_Count"]),
        totalVaccineCount: int.parse(json["Total_Vaccine_Count"]),
        imageUrl: json["Image_Url"]);
  }
}

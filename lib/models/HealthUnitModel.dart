class HealthUnitModel {
  int id;
  String unitName;
  String unitAdress;
  String unitPhone;
  int ministaryId;
  String imageUrl;

  HealthUnitModel(
      {this.id,
      this.unitName,
      this.unitAdress,
      this.unitPhone,
      this.ministaryId,
      this.imageUrl});

  factory HealthUnitModel.fromJson(Map<String, dynamic> json) {
    return HealthUnitModel(
      id: json["Id"],
      unitName: json["Unit_Name"],
      unitAdress: json["Unit_Adress"],
      unitPhone: json["Unit_Phone"],
      ministaryId: json["Ministary_Id"],
      imageUrl: json["Image_Url"],
    );
  }
}

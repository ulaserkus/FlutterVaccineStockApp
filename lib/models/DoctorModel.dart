class DoctorModel {
  int id;
  String doctorFullName;
  String doctorPhone;
  String doctorAddress;
  int unitId;
  String imageUrl;
  String unitName;

  DoctorModel(
      {this.id,
      this.doctorFullName,
      this.doctorPhone,
      this.doctorAddress,
      this.unitId,
      this.imageUrl,
      this.unitName});

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
        id: json["Id"],
        doctorFullName: json["Doctor_FullName"],
        doctorPhone: json["Doctor_Phone"],
        doctorAddress: json["Doctor_Adress"],
        unitId: json["Unit_Id"],
        imageUrl: json["Image_Url"],
        unitName: json["Unit_Name"]);
  }
}

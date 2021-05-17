class PatientTableModel {
  int id;
  String patientFullName;
  String patientPhone;
  String patientAddress;
  int patientAge;
  bool hasVaccinated;
  bool hasCronicPatient;
  String imageUrl;
  int unitId;
  int ministaryId;

  PatientTableModel(
      {this.id,
      this.patientFullName,
      this.patientPhone,
      this.patientAddress,
      this.patientAge,
      this.hasVaccinated,
      this.hasCronicPatient,
      this.imageUrl,
      this.unitId,
      this.ministaryId});

  factory PatientTableModel.fromJson(Map<String, dynamic> json) {
    return PatientTableModel(
      id: json["Id"],
      patientFullName: json["Patient_FullName"],
      patientAddress: json["Patient_Adress"],
      patientAge: json["Patient_Age"],
      patientPhone: json["Patient_Phone"],
      hasVaccinated: json["HasVaccinated"],
      hasCronicPatient: json["HasCronicPatient"],
      imageUrl: json["Image_Url"],
      ministaryId: json["Ministary_Id"],
      unitId: json["Unit_Id"],
    );
  }
}

class PatientModel {
  final int id;
  final int patientId;
  final String patientFullName;
  final int patientAge;
  final String patientAddress;
  final String patientPhone;
  final bool hasVaccinated;
  final bool hasCronicPatient;
  final String imageUrl;

  PatientModel(
      {this.id,
      this.patientId,
      this.patientFullName,
      this.patientPhone,
      this.patientAge,
      this.patientAddress,
      this.hasVaccinated,
      this.hasCronicPatient,
      this.imageUrl});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
        id: json["Id"],
        patientId: json["Patient_Id"],
        patientFullName: json["Patient_FullName"],
        patientAge: json["Patient_Age"],
        patientAddress: json["Patient_Adress"],
        patientPhone: json["Patient_Phone"],
        hasCronicPatient: json["HasCronicPatient"],
        hasVaccinated: json["HasVaccinated"],
        imageUrl: json["Image_Url"]);
  }
}

class PatientAppointmentModel {
  int id;
  int doctorId;
  int doctorPatientId;
  String doctorFullName;
  String unitName;
  String unitAddress;
  String appointmentDate;
  int patientId;
  String patientFullName;
  int patientAge;
  String patientPhone;
  String patientAddress;
  bool hasVaccinated;
  bool hasCronicPatient;
  int priority;
  String imageUrl;
  int unitId;

  PatientAppointmentModel(
      {this.appointmentDate,
      this.doctorFullName,
      this.doctorId,
      this.doctorPatientId,
      this.hasCronicPatient,
      this.hasVaccinated,
      this.id,
      this.imageUrl,
      this.patientAddress,
      this.patientAge,
      this.patientFullName,
      this.patientId,
      this.patientPhone,
      this.priority,
      this.unitAddress,
      this.unitId,
      this.unitName});

  factory PatientAppointmentModel.fromJson(Map<String, dynamic> json) {
    return PatientAppointmentModel(
        id: json["Id"],
        doctorId: json["Doctor_Id"],
        doctorFullName: json["Doctor_FullName"],
        unitName: json["Unit_Name"],
        unitAddress: json["Unit_Adress"],
        appointmentDate: json["Appointment_Date"],
        patientId: json["Patient_Id"],
        patientFullName: json["Patient_FullName"],
        patientAge: json["Patient_Age"],
        patientPhone: json["Patient_Phone"],
        hasVaccinated: json["HasVaccinated"],
        hasCronicPatient: json["HasCronicPatient"],
        priority: json["Priority"],
        imageUrl: json["Image_Url"],
        unitId: json["Unit_Id"],
        doctorPatientId: json["Doctor_Patient_Id"],
        patientAddress: json["Patient_Adress"]);
  }
}

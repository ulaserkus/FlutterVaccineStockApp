class ProducerStockModel {
  int producerId;
  int stockId;
  int vaccineId;
  String producerName;
  String producerPhone;
  String producerEmail;
  String producerAdress;
  String producerCountry;
  int id;
  String vaccineName;
  int vaccineCount;
  String lastProductionDate;
  String imageUrl;

  ProducerStockModel(
      {this.producerId,
      this.stockId,
      this.vaccineId,
      this.producerName,
      this.producerPhone,
      this.producerEmail,
      this.producerAdress,
      this.producerCountry,
      this.id,
      this.vaccineName,
      this.vaccineCount,
      this.lastProductionDate,
      this.imageUrl});

  factory ProducerStockModel.fromJson(Map<String, dynamic> json) {
    return ProducerStockModel(
      producerId: json["Producer_Id"],
      stockId: json["Stock_Id"],
      vaccineId: json["Vaccine_Id"],
      producerName: json["Producer_Name"],
      producerPhone: json["Producer_Phone"],
      producerEmail: json["Producer_Email"],
      producerAdress: json["Producer_Adress"],
      producerCountry: json["Producer_Country"],
      id: json["Id"],
      vaccineName: json["Vaccine_Name"],
      vaccineCount: int.parse(json["Vaccine_Count"]),
      lastProductionDate: json["Last_Production_Date"],
      imageUrl: json["Image_Url"],
    );
  }
}

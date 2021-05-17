class WorldStockModel {
  String producerName;
  double totalStock;

  WorldStockModel({this.producerName, this.totalStock});

  factory WorldStockModel.fromJson(Map<String, dynamic> json) {
    return WorldStockModel(
        producerName: json["Producer_Name"],
        totalStock: double.parse(json["Total_Stock"]));
  }
}

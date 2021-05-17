import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_stock_app/data/AdminData.dart';
import 'package:flutter_stock_app/models/WorldStockModel.dart';
import 'package:flutter_stock_app/models/WorldVaccineModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InfoPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InfoPanelState();
  }
}

class InfoPanelState extends State<InfoPanel> {
  bool status = false;
  bool load = false;
  List<WorldStockModel> stockList;
  List<WorldVaccineModel> vaccineList;
  List<_PieData> pieDataStock = [];
  List<_PieData> pieDataVaccine = [];
  @override
  void initState() {
    super.initState();
    this.status = false;
    getData();
  }

  getData() async {
    stockList = await AdminData.getPercantagesOfStocks();
    vaccineList = await AdminData.getPercantagesOfVaccine();
    addDataToPieStock();

    setState(() {
      load = true;
    });
  }

  addDataToPieStock() {
    var totalStock = stockList.fold(
        0, (previousValue, element) => previousValue += element.totalStock);
    var totalVaccine = vaccineList.fold(0,
        (previousValue, element) => previousValue += element.totalVaccineCount);
    stockList.forEach((element) {
      var pie = _PieData(element.producerName,
          (element.totalStock / totalStock * 100).floor());
      pieDataStock.add(pie);
    });
    vaccineList.forEach((element) {
      var pie = _PieData(element.ministaryCountry,
          (element.totalVaccineCount / totalVaccine * 100).floor());

      pieDataVaccine.add(pie);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return load
        ? BootstrapContainer(fluid: true, children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: BootstrapRow(height: screenHeight / 2, children: [
                BootstrapCol(
                    sizes: 'col-6',
                    child: SizedBox(
                      height: 125,
                      child: DecoratedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.recycle,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Text(
                                  'E-Hizmetler',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(23, 162, 184, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3))
                            ]),
                      ),
                    )),
                BootstrapCol(
                    sizes: 'col-lg-6',
                    child: SizedBox(
                      height: 125,
                      child: DecoratedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.solidBuilding,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                Text(
                                  'Kurumlar',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(23, 162, 184, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3))
                            ]),
                      ),
                    )),
                BootstrapCol(
                    sizes: 'col-6',
                    offsets: 'offset',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: 125,
                        child: DecoratedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.industry,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  Text(
                                    'Firmalar',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(23, 162, 184, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3))
                              ]),
                        ),
                      ),
                    )),
                BootstrapCol(
                    sizes: 'col-6',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: 125,
                        child: DecoratedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidComments,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  Text(
                                    'Hızlı Çözüm',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(23, 162, 184, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3))
                              ]),
                        ),
                      ),
                    )),
                BootstrapCol(
                    sizes: 'col-12',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: screenHeight / 2,
                        child: DecoratedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              status
                                  ? Expanded(
                                      flex: 5,
                                      child: SfCircularChart(
                                        title: ChartTitle(
                                            text: "Dünya Aşı Dağılımı",
                                            textStyle:
                                                TextStyle(color: Colors.white)),
                                        legend: Legend(
                                            position: LegendPosition.top,
                                            isVisible: true,
                                            textStyle:
                                                TextStyle(color: Colors.white)),
                                        series: <PieSeries<_PieData, String>>[
                                          PieSeries<_PieData, String>(
                                              explode: true,
                                              explodeIndex: 0,
                                              dataSource: pieDataVaccine,
                                              xValueMapper:
                                                  (_PieData data, _) =>
                                                      data.xData,
                                              yValueMapper:
                                                  (_PieData data, _) =>
                                                      data.yData,
                                              dataLabelMapper:
                                                  (_PieData data, _) =>
                                                      data.text,
                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                      isVisible: true)),
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      flex: 5,
                                      child: SfCircularChart(
                                        title: ChartTitle(
                                            text: "Dünya Stok Dağılımı",
                                            textStyle:
                                                TextStyle(color: Colors.white)),
                                        legend: Legend(
                                            position: LegendPosition.top,
                                            isVisible: true,
                                            textStyle:
                                                TextStyle(color: Colors.white)),
                                        series: <PieSeries<_PieData, String>>[
                                          PieSeries<_PieData, String>(
                                              explode: true,
                                              explodeIndex: 0,
                                              dataSource: pieDataStock,
                                              xValueMapper:
                                                  (_PieData data, _) =>
                                                      data.xData,
                                              yValueMapper:
                                                  (_PieData data, _) =>
                                                      data.yData,
                                              dataLabelMapper:
                                                  (_PieData data, _) =>
                                                      data.text,
                                              dataLabelSettings:
                                                  DataLabelSettings(
                                                      isVisible: true)),
                                        ],
                                      ),
                                    ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 300),
                                    child: Switch(
                                      activeColor: Colors.white,
                                      activeTrackColor: Colors.white,
                                      value: this.status,
                                      onChanged: (bool val) {
                                        setState(() {
                                          this.status = val;
                                        });
                                      },
                                    ),
                                  ))
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(23, 162, 184, 1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 6))
                              ]),
                        ),
                      ),
                    )),
              ]),
            ),
          ])
        : Center(
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(23, 162, 184, 1)),
              backgroundColor: Colors.white,
            ),
          );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  final String text;
}

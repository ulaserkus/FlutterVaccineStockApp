import 'package:alertify/alertify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stock_app/data/HealthUnitData.dart';
import 'package:flutter_stock_app/models/DoctorModel.dart';
import 'package:flutter_stock_app/models/HealthUnitModel.dart';
import 'package:flutter_stock_app/models/PatientModel.dart';
import 'package:flutter_stock_app/models/ReportModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';

// ignore: must_be_immutable
class HealthUnitPanel extends StatefulWidget {
  bool openMenu;
  HealthUnitPanel({this.openMenu});
  @override
  State<StatefulWidget> createState() {
    return HealthUnitPanelState();
  }
}

class HealthUnitPanelState extends State<HealthUnitPanel> {
  int selectedIndex = 0;
  bool loading = false;
  final storage = new FlutterSecureStorage();
  int unitId = 0;
  HealthUnitModel unit;
  List<PatientModel> patients = [];
  List<DoctorModel> doctors = [];
  List<ReportModel> reports = [];

  @override
  void initState() {
    super.initState();
    getUnitId();
  }

  getUnitId() async {
    var key = await storage.read(key: "token");
    var userObj = Jwt.parseJwt(key);
    this.unitId = userObj["unit_id"];
    print(this.unitId);
    getData();
  }

  getData() async {
    unit = await HealthUnitData.getUnitById(this.unitId);
    reports = await HealthUnitData.getReportsByUnitId(this.unitId);
    doctors = await HealthUnitData.getDoctorsByUnitId(this.unitId);
    patients = await HealthUnitData.getPatientsByUnitId(this.unitId);
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Row(
              children: [
                widget.openMenu
                    ? Container(
                        child: Row(
                          children: [
                            NavigationRail(
                              selectedLabelTextStyle:
                                  TextStyle(color: Colors.white),
                              backgroundColor: Color.fromRGBO(23, 162, 184, 1),
                              selectedIndex: selectedIndex,
                              onDestinationSelected: (int index) {
                                setState(() {
                                  selectedIndex = index;
                                });

                                print(widget.openMenu);
                              },
                              labelType: NavigationRailLabelType.selected,
                              destinations: [
                                NavigationRailDestination(
                                    icon: Icon(Icons.home),
                                    selectedIcon: Icon(
                                      Icons.home_filled,
                                      color: Colors.white,
                                    ),
                                    label: Text("Anasayfa")),
                                NavigationRailDestination(
                                    icon: FaIcon(FontAwesomeIcons.notesMedical),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.notesMedical,
                                      color: Colors.white,
                                    ),
                                    label: Text("Raporlar")),
                                NavigationRailDestination(
                                    icon: FaIcon(FontAwesomeIcons.bookMedical),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.bookMedical,
                                      color: Colors.white,
                                    ),
                                    label: Text("Doktorlar")),
                                NavigationRailDestination(
                                    icon:
                                        FaIcon(FontAwesomeIcons.laptopMedical),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.laptopMedical,
                                      color: Colors.white,
                                    ),
                                    label: Text("Hastalar")),
                              ],
                            ),
                            selectedWidget()
                          ],
                        ),
                      )
                    : menuDisabled()
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(23, 162, 184, 1)),
                backgroundColor: Colors.white,
              ),
            ),
    );
  }

  //# Menu Active
  Widget selectedWidget() {
    double screenWidth = MediaQuery.of(context).size.width;

    if (selectedIndex == 0 && widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  width: screenWidth - 115,
                  child: DecoratedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(unit.imageUrl),
                                  radius: 60,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    unit.unitName.length > 17
                                        ? unit.unitName.substring(0, 17)
                                        : unit.unitName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Adres :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        unit.unitAdress.replaceRange(
                                            17, unit.unitAdress.length, '...'),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Telefon :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        unit.unitPhone,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
              ),
            )
          ]));
    } else if (selectedIndex == 1 && widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  width: screenWidth - 115,
                  child: DecoratedBox(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: reports.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          onTap: () {
                            print("tile clicked");
                          },
                          trailing: IconButton(
                              icon: Icon(Icons.delete_forever,
                                  color: Colors.redAccent),
                              onPressed: () async {
                                final response =
                                    await HealthUnitData.deleteReportById(
                                        reports[i].id);

                                if (response.statusCode == 200) {
                                  Alertify(
                                          content: "Rapor Silme Başarılı.",
                                          title: "Başarılı",
                                          animationType:
                                              AnimationType.bottomToTop,
                                          alertType: AlertifyType.success,
                                          buttonText: "OK",
                                          isDismissible: true,
                                          context: context)
                                      .show();

                                  setState(() {
                                    getData();
                                  });
                                }
                              }),
                          title: Text(reports[i].reportDate.split('T')[0],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          subtitle: Text(
                            "İhtiyaç : " + reports[i].unitNeeds.toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
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
              ),
            )
          ]));
    } else if (selectedIndex == 2 && widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: screenWidth - 115,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: DecoratedBox(
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: doctors.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                onTap: () {
                                  print("tile clicked");
                                },
                                trailing: IconButton(
                                    icon: Icon(Icons.delete_forever,
                                        color: Colors.redAccent),
                                    onPressed: () async {
                                      final response =
                                          await HealthUnitData.deleteDoctorById(
                                              doctors[i].id);

                                      if (response.statusCode == 200) {
                                        Alertify(
                                                content:
                                                    "Doktor silme başarılı",
                                                isDismissible: true,
                                                context: context,
                                                alertType: AlertifyType.success,
                                                animationType:
                                                    AnimationType.bottomToTop,
                                                buttonText: "OK",
                                                title: "Başarılı")
                                            .show();

                                        setState(() {
                                          getData();
                                        });
                                      }
                                    }),
                                title: Text("Dr." + doctors[i].doctorFullName,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              );
                            },
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
                    ],
                  ),
                ),
              ),
            )
          ]));
    } else if (selectedIndex == 3 && widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  width: screenWidth - 115,
                  child: DecoratedBox(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: patients.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          onTap: () {
                            print("tile clicked");
                          },
                          trailing: IconButton(
                              icon: Icon(Icons.delete_forever_sharp,
                                  color: Colors.redAccent),
                              onPressed: () async {
                                final response =
                                    await HealthUnitData.deletePatientById(
                                        patients[i].id);
                                if (response.statusCode == 200) {
                                  Alertify(
                                          content: "Hasta Silme Başarılı.",
                                          title: "Başarılı",
                                          animationType:
                                              AnimationType.bottomToTop,
                                          alertType: AlertifyType.success,
                                          buttonText: "OK",
                                          isDismissible: true,
                                          context: context)
                                      .show();

                                  setState(() {
                                    getData();
                                  });
                                }
                              }),
                          title: Text(patients[i].patientFullName,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        );
                      },
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
              ),
            )
          ]));
    } else {
      return null;
    }
  }

  //# Menu Disabled
  Widget menuDisabled() {
    double screenWidth = MediaQuery.of(context).size.width;
    if (selectedIndex == 0 && !widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  width: screenWidth - 40,
                  child: DecoratedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: screenWidth - 40,
                              height: 50,
                              child: DecoratedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Anasayfa",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(247, 247, 247, 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5)))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(unit.imageUrl),
                                  radius: 60,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 60),
                                  child: Text(
                                    unit.unitName.length > 17
                                        ? unit.unitName.substring(0, 17)
                                        : unit.unitName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Adres :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        unit.unitAdress.replaceRange(
                                            22, unit.unitAdress.length, '...'),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                          "Telefon :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        unit.unitPhone,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
              ),
            )
          ]));
    } else if (selectedIndex == 1 && !widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: SizedBox(
                  width: screenWidth - 40,
                  child: DecoratedBox(
                    child: Column(children: [
                      SizedBox(
                        width: screenWidth - 40,
                        height: 50,
                        child: DecoratedBox(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Raporlar",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color.fromRGBO(
                                                23, 162, 184, 1)),
                                        onPressed: () {
                                          showAddReportModal(context);
                                        },
                                        child: Text("Yeni Rapor")),
                                  )
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(247, 247, 247, 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 170,
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: reports.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              onTap: () {
                                print("tile clicked");
                              },
                              trailing: IconButton(
                                  icon: Icon(Icons.delete_forever,
                                      color: Colors.redAccent),
                                  onPressed: () async {
                                    final response =
                                        await HealthUnitData.deleteReportById(
                                            reports[i].id);

                                    if (response.statusCode == 200) {
                                      Alertify(
                                              content: "Rapor Silme Başarılı.",
                                              title: "Başarılı",
                                              animationType:
                                                  AnimationType.bottomToTop,
                                              alertType: AlertifyType.success,
                                              buttonText: "OK",
                                              isDismissible: true,
                                              context: context)
                                          .show();

                                      setState(() {
                                        getData();
                                      });
                                    }
                                  }),
                              title: Text(reports[i].reportDate.split('T')[0],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              subtitle: Text(
                                "İhtiyaç : " + reports[i].unitNeeds.toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
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
              ),
            ],
          ));
    } else if (selectedIndex == 2 && !widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: screenWidth - 40,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: DecoratedBox(
                          child: Column(
                            children: [
                              SizedBox(
                                width: screenWidth - 40,
                                height: 50,
                                child: DecoratedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Doktorlar",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: Color.fromRGBO(
                                                        23, 162, 184, 1)),
                                                onPressed: () {
                                                  showDoctorModal(context);
                                                },
                                                child: Text("Doktor Ekle"),
                                              )),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(247, 247, 247, 0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),
                              ),
                              SizedBox(
                                height: 200,
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: doctors.length,
                                  itemBuilder: (context, i) {
                                    return ListTile(
                                      onTap: () {
                                        print("tile clicked");
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(doctors[i].imageUrl),
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.delete_forever,
                                              color: Colors.redAccent),
                                          onPressed: () async {
                                            final response =
                                                await HealthUnitData
                                                    .deleteDoctorById(
                                                        doctors[i].id);

                                            if (response.statusCode == 200) {
                                              Alertify(
                                                      content:
                                                          "Doktor silme başarılı",
                                                      isDismissible: true,
                                                      context: context,
                                                      alertType:
                                                          AlertifyType.success,
                                                      animationType:
                                                          AnimationType
                                                              .bottomToTop,
                                                      buttonText: "OK",
                                                      title: "Başarılı")
                                                  .show();

                                              setState(() {
                                                getData();
                                              });
                                            }
                                          }),
                                      title: Text(
                                          "Dr." + doctors[i].doctorFullName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                    );
                                  },
                                ),
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
                    ],
                  ),
                ),
              ),
            )
          ]));
    } else if (selectedIndex == 3 && !widget.openMenu) {
      return Container(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Flexible(
              child: Container(
                child: SizedBox(
                  width: screenWidth - 40,
                  child: DecoratedBox(
                    child: Column(
                      children: [
                        SizedBox(
                          width: screenWidth - 40,
                          height: 50,
                          child: DecoratedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Hastalar",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: Color.fromRGBO(
                                                23, 162, 184, 1)),
                                        child: Text("Hasta Ekle"),
                                        onPressed: () {
                                          showPatientModal(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(247, 247, 247, 0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 170,
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: patients.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                onTap: () {
                                  print("tile clicked");
                                },
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(patients[i].imageUrl),
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.delete_forever_sharp,
                                        color: Colors.redAccent),
                                    onPressed: () async {
                                      final response = await HealthUnitData
                                          .deletePatientById(patients[i].id);
                                      if (response.statusCode == 200) {
                                        Alertify(
                                                content:
                                                    "Hasta Silme Başarılı.",
                                                title: "Başarılı",
                                                animationType:
                                                    AnimationType.bottomToTop,
                                                alertType: AlertifyType.success,
                                                buttonText: "OK",
                                                isDismissible: true,
                                                context: context)
                                            .show();

                                        setState(() {
                                          getData();
                                        });
                                      }
                                    }),
                                title: Text(patients[i].patientFullName,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              );
                            },
                          ),
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
              ),
            )
          ]));
    } else {
      return null;
    }
  }

  showAddReportModal(context) async {
    final vaccineCount = TextEditingController();
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return SingleChildScrollView(
                child: Container(
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        alignment: Alignment.topLeft,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5, left: 20),
                                child: Text(
                                  "Rapor Oluştur",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Color.fromRGBO(23, 162, 184, 1)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5, left: 5),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Kapat",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: const Color(0xfff8f8f8),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: 300,
                              height: 50,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Color.fromRGBO(23, 162, 184, 1))),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 20),
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      controller: vaccineCount,
                                      validator: (value) {
                                        Pattern pattern = r'^[0-9]*$';
                                        RegExp regex = new RegExp(pattern);
                                        if (value == null || value.isEmpty) {
                                          return 'Değer giriniz';
                                        }
                                        if (!regex.hasMatch(value)) {
                                          return 'Sayı giriniz';
                                        }

                                        Pattern space = r"\s+";
                                        RegExp spaceRegex = new RegExp(space);

                                        if (spaceRegex.hasMatch(value)) {
                                          return 'Boşluk kullanmayınız';
                                        }

                                        return null;
                                      },
                                    )),
                              ),
                            ),
                          ),
                          Container(
                              width: 100,
                              margin: EdgeInsets.only(bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(23, 162, 184, 1)),
                                child: Text("Oluştur"),
                                onPressed: () async {
                                  DateTime today =
                                      DateTime.parse(DateTime.now().toString());
                                  Object reportObj = {
                                    "count": vaccineCount.text,
                                    "need": vaccineCount.text,
                                    "date":
                                        today.toIso8601String().split('.')[0],
                                    "unitid": unitId
                                  };
                                  final response =
                                      await HealthUnitData.createReport(
                                          reportObj);
                                  if (response.statusCode == 200) {
                                    Alertify(
                                            content:
                                                "Rapor Oluşturma Başarılı.",
                                            title: "Başarılı",
                                            animationType:
                                                AnimationType.bottomToTop,
                                            alertType: AlertifyType.success,
                                            buttonText: "OK",
                                            isDismissible: true,
                                            context: context)
                                        .show();

                                    setState(() {
                                      getData();
                                    });
                                  }
                                },
                              )),
                        ]))));
          });
        });
  }

  showDoctorModal(context) async {
    final formKey = GlobalKey<FormState>();
    final doctorName = TextEditingController();
    final doctorPhone = TextEditingController();
    final doctorAddress = TextEditingController();
    final doctorImage = TextEditingController();

    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SingleChildScrollView(
                child: Container(
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        alignment: Alignment.topLeft,
                        child: Column(children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5, left: 20),
                                child: Text(
                                  "Doktor Ekle",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Color.fromRGBO(23, 162, 184, 1)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5, left: 5),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Kapat",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: const Color(0xfff8f8f8),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    BootstrapRow(height: 80, children: [
                                      BootstrapCol(
                                        sizes: 'col-6',
                                        child: TextFormField(
                                          controller: doctorName,
                                          decoration: InputDecoration(
                                            labelText: "Ad-Soyad",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            Pattern pattern = r'^([a-zA-Z])';

                                            RegExp regex = new RegExp(pattern);

                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }
                                            if (!regex.hasMatch(value)) {
                                              return 'Kelime giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      BootstrapCol(
                                        sizes: 'col-6',
                                        child: TextFormField(
                                          controller: doctorPhone,
                                          decoration: InputDecoration(
                                            labelText: "Telefon",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ]),
                                    BootstrapRow(height: 80, children: [
                                      BootstrapCol(
                                        sizes: 'col-12',
                                        child: TextFormField(
                                          controller: doctorAddress,
                                          decoration: InputDecoration(
                                            labelText: "Adres",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ]),
                                    BootstrapRow(height: 80, children: [
                                      BootstrapCol(
                                        sizes: 'col-12',
                                        child: TextFormField(
                                          controller: doctorImage,
                                          decoration: InputDecoration(
                                            labelText: "Resim",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ]),
                                    BootstrapCol(
                                        sizes: 'col-6',
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromRGBO(
                                                  23, 162, 184, 1),
                                              side: BorderSide(
                                                color: Colors.white,
                                              )),
                                          child: Text("Kaydet"),
                                          onPressed: () async {
                                            if (formKey.currentState
                                                .validate()) {
                                              Object doctorObj = {
                                                "name": doctorName.text,
                                                "phone": doctorPhone.text,
                                                "adress": doctorAddress.text,
                                                "unitid": unitId,
                                                "imageurl": doctorImage.text
                                              };

                                              final response =
                                                  await HealthUnitData
                                                      .createDoctor(doctorObj);

                                              if (response.statusCode == 200) {
                                                Alertify(
                                                        context: context,
                                                        isDismissible: true,
                                                        alertType: AlertifyType
                                                            .success,
                                                        title: 'Başarılı',
                                                        buttonText: 'OK',
                                                        animationType:
                                                            AnimationType
                                                                .bottomToTop,
                                                        content:
                                                            "Doktor Ekleme Başarılı.")
                                                    .show();

                                                setState(() {
                                                  getData();
                                                });
                                              }
                                            }
                                          },
                                        )),
                                  ],
                                ),
                              ))
                        ]))),
              );
            },
          );
        });
  }

  showPatientModal(context) async {
    final formKey = GlobalKey<FormState>();
    final patientName = TextEditingController();
    final patientPhone = TextEditingController();
    final patientAddress = TextEditingController();
    final patientImage = TextEditingController();
    final patientAge = TextEditingController();
    final patientNo = TextEditingController();
    bool cronicPatient = false;

    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SingleChildScrollView(
                child: Container(
                    color: Colors.transparent,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        alignment: Alignment.topLeft,
                        child: Column(children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 5, left: 20),
                                child: Text(
                                  "Hasta Ekle",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Color.fromRGBO(23, 162, 184, 1)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5, left: 5),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Kapat",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: const Color(0xfff8f8f8),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    BootstrapRow(height: 80, children: [
                                      BootstrapCol(
                                        sizes: 'col-12',
                                        child: TextFormField(
                                          controller: patientNo,
                                          decoration: InputDecoration(
                                            labelText: "TC No",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }

                                            if (value.length != 11) {
                                              return '11 haneli değer giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ]),
                                    BootstrapRow(height: 80, children: [
                                      BootstrapCol(
                                        sizes: 'col-6',
                                        child: TextFormField(
                                          controller: patientName,
                                          decoration: InputDecoration(
                                            labelText: "Ad-Soyad",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            Pattern pattern = r'^([a-zA-Z])';

                                            RegExp regex = new RegExp(pattern);

                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }
                                            if (!regex.hasMatch(value)) {
                                              return 'Kelime giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      BootstrapCol(
                                        sizes: 'col-6',
                                        child: TextFormField(
                                          controller: patientAge,
                                          decoration: InputDecoration(
                                            labelText: "Yaş",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ]),
                                    BootstrapRow(height: 80, children: [
                                      BootstrapCol(
                                        sizes: 'col-6',
                                        child: TextFormField(
                                          controller: patientAddress,
                                          decoration: InputDecoration(
                                            labelText: "Adres",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      BootstrapCol(
                                        sizes: 'col-6',
                                        child: TextFormField(
                                          controller: patientPhone,
                                          decoration: InputDecoration(
                                            labelText: "Telefon",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                    ]),
                                    BootstrapRow(height: 80, children: [
                                      BootstrapCol(
                                        sizes: 'col-6',
                                        child: TextFormField(
                                          controller: patientImage,
                                          decoration: InputDecoration(
                                            labelText: "Resim",
                                            labelStyle: TextStyle(
                                                color: Colors.black87),
                                            fillColor: Colors.white,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    23, 162, 184, 1),
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      BootstrapCol(
                                        sizes: 'col-6',
                                        child: Column(
                                          children: [
                                            Text(
                                              'Cronic Patient',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Transform.scale(
                                              scale: 1.5,
                                              child: Checkbox(
                                                  value: cronicPatient,
                                                  activeColor: Color.fromRGBO(
                                                      23, 162, 184, 1),
                                                  onChanged: (bool newValue) {
                                                    setState(() {
                                                      cronicPatient = newValue;
                                                    });
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                                    BootstrapCol(
                                        sizes: 'col-6',
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color.fromRGBO(
                                                  23, 162, 184, 1),
                                              side: BorderSide(
                                                color: Colors.white,
                                              )),
                                          child: Text("Kaydet"),
                                          onPressed: () async {
                                            if (formKey.currentState
                                                .validate()) {
                                              Object patientObj = {
                                                "name": patientName.text,
                                                "age": patientAge.text,
                                                "phone": patientPhone.text,
                                                "address": patientAddress.text,
                                                "img": patientImage.text,
                                                "cronic": cronicPatient,
                                                "vaccinated": false,
                                                "unitid": unitId
                                              };
                                              final response =
                                                  await HealthUnitData
                                                      .createPatient(
                                                          patientObj);

                                              if (response.statusCode == 200) {
                                                Map<String, dynamic> res =
                                                    await HealthUnitData
                                                        .getLastPatientId();

                                                Object userObj = {
                                                  "username": patientNo.text,
                                                  "password": "1",
                                                  "role": "patient",
                                                  "ministary_id": null,
                                                  "patient_id": res["Id"],
                                                  "doctor_id": null,
                                                  "unit_id": null,
                                                  "producer_id": null
                                                };
                                                var response =
                                                    await HealthUnitData
                                                        .createUser(userObj);

                                                if (response.statusCode ==
                                                    200) {
                                                  Alertify(
                                                          context: context,
                                                          isDismissible: true,
                                                          alertType:
                                                              AlertifyType
                                                                  .success,
                                                          title: 'Başarılı',
                                                          buttonText: 'OK',
                                                          animationType:
                                                              AnimationType
                                                                  .bottomToTop,
                                                          content:
                                                              "Hasta Ekleme Başarılı.")
                                                      .show();

                                                  setState(() {
                                                    getData();
                                                  });
                                                }
                                              }
                                            }
                                          },
                                        )),
                                  ],
                                ),
                              ))
                        ]))),
              );
            },
          );
        });
  }
}

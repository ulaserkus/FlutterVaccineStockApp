import 'package:alertify/alertify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stock_app/data/DoctorData.dart';
import 'package:flutter_stock_app/models/DoctorModel.dart';
import 'package:flutter_stock_app/models/HealthUnitModel.dart';
import 'package:flutter_stock_app/models/PatientAppointmentModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';

// ignore: must_be_immutable
class DoctorPanel extends StatefulWidget {
  bool openMenu;
  DoctorPanel({this.openMenu});
  @override
  State<StatefulWidget> createState() {
    return DoctorPanelState();
  }
}

class DoctorPanelState extends State<DoctorPanel> {
  int selectedIndex = 0;
  int doctorId = 0;
  bool loading = false;
  DoctorModel doctor;
  HealthUnitModel unit;
  List<PatientAppointmentModel> phaseOne = [];
  List<PatientAppointmentModel> phaseTwo = [];
  List<PatientAppointmentModel> phaseExtra = [];
  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getDoctorId();
  }

  getDoctorId() async {
    var key = await storage.read(key: "token");
    var userObj = Jwt.parseJwt(key);
    this.doctorId = userObj["doctor_id"];
    getData();
  }

  getData() async {
    doctor = await DoctorData.getDoctorById(this.doctorId);
    unit = await DoctorData.getUnitByDoctorId(this.doctorId);
    phaseOne =
        await DoctorData.getPhaseOneAppointmentsByDoctorId(this.doctorId);

    phaseTwo =
        await DoctorData.getPhaseTwoAppointmentsByDoctorId(this.doctorId);

    phaseExtra =
        await DoctorData.getPhaseExtraAppointmentsByDoctorId(this.doctorId);

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
                                    icon:
                                        FaIcon(FontAwesomeIcons.clinicMedical),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.clinicMedical,
                                      color: Colors.white,
                                    ),
                                    label: Text("Birim")),
                                NavigationRailDestination(
                                    icon: FaIcon(FontAwesomeIcons.notesMedical),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.notesMedical,
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
                                  backgroundImage:
                                      NetworkImage(doctor.imageUrl),
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
                                    doctor.doctorFullName,
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
                                            const EdgeInsets.only(right: 5),
                                        child: Text(
                                          "Telefon :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        doctor.doctorPhone,
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
                                            const EdgeInsets.only(right: 5),
                                        child: Text(
                                          "Adres :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        doctor.doctorAddress,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Container(
                                    child: Text(
                                      unit.unitName.length <= 20
                                          ? unit.unitName
                                          : unit.unitName.substring(0, 20),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Text(
                                          "Adres :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        unit.unitAdress
                                            .replaceRange(24, 27, '...')
                                            .substring(0, 27),
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
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: DecoratedBox(
                            child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: phaseOne.length,
                              itemBuilder: (context, i) {
                                return ListTile(
                                  onTap: () {
                                    print("tile clicked");
                                  },
                                  trailing: Wrap(children: [
                                    IconButton(
                                        icon: Icon(Icons.check_circle,
                                            color: Colors.greenAccent),
                                        onPressed: () async {
                                          DateTime newDate = DateTime.parse(
                                                  phaseOne[i].appointmentDate)
                                              .add(Duration(days: 30));
                                          Object appObj = {
                                            "doctorid": phaseOne[i].doctorId,
                                            "patientid": phaseOne[i].patientId,
                                            "date": newDate
                                                .toIso8601String()
                                                .split('.')[0],
                                            "priority": phaseOne[i].priority
                                          };
                                          Object phaseObj = {
                                            "phase": 2,
                                            "doctorpatientid":
                                                phaseOne[i].doctorPatientId
                                          };
                                          final response =
                                              await DoctorData.deletePhaseState(
                                                  phaseOne[i].id);
                                          if (response.statusCode == 200) {
                                            final response = await DoctorData
                                                .createAppointment(appObj);

                                            if (response.statusCode == 200) {
                                              final response = await DoctorData
                                                  .createPhaseState(phaseObj);

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
                                                            "Faz 1 Başarılı.")
                                                    .show();

                                                setState(() {
                                                  getData();
                                                });
                                              }
                                            }
                                          }
                                        }),
                                    IconButton(
                                        icon: Icon(Icons.close,
                                            color: Colors.redAccent),
                                        onPressed: () async {
                                          final response =
                                              await DoctorData.deletePhaseState(
                                                  phaseOne[i].id);

                                          if (response.statusCode == 200) {
                                            Alertify(
                                                    context: context,
                                                    isDismissible: true,
                                                    alertType:
                                                        AlertifyType.success,
                                                    title: 'Başarılı',
                                                    buttonText: 'OK',
                                                    animationType: AnimationType
                                                        .bottomToTop,
                                                    content:
                                                        "Silme işlemi Başarılı.")
                                                .show();

                                            setState(() {
                                              getData();
                                            });
                                          }
                                        }),
                                  ]),
                                  title: Text(
                                      phaseOne[i].patientFullName +
                                          " " +
                                          phaseOne[i].patientAge.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  subtitle: Text(
                                    "Tarih : " +
                                        phaseOne[i]
                                            .appointmentDate
                                            .split('T')[0],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: DecoratedBox(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: phaseTwo.length,
                              itemBuilder: (context, i) {
                                return ListTile(
                                  onTap: () {
                                    print("tile clicked");
                                  },
                                  trailing: Wrap(children: [
                                    IconButton(
                                        icon: Icon(Icons.skip_next,
                                            color: Colors.white),
                                        onPressed: () async {
                                          DateTime newDate = DateTime.parse(
                                                  phaseTwo[i].appointmentDate)
                                              .add(Duration(days: 30));
                                          Object appObj = {
                                            "doctorid": phaseTwo[i].doctorId,
                                            "patientid": phaseTwo[i].patientId,
                                            "date": newDate
                                                .toIso8601String()
                                                .split('.')[0],
                                            "priority": phaseTwo[i].priority
                                          };
                                          Object phaseObj = {
                                            "phase": 3,
                                            "doctorpatientid":
                                                phaseTwo[i].doctorPatientId
                                          };
                                          final response =
                                              await DoctorData.deletePhaseState(
                                                  phaseTwo[i].id);
                                          if (response.statusCode == 200) {
                                            final response = await DoctorData
                                                .createAppointment(appObj);

                                            if (response.statusCode == 200) {
                                              final response = await DoctorData
                                                  .createPhaseState(phaseObj);

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
                                                            "Faz 1 Başarılı.")
                                                    .show();

                                                setState(() {
                                                  getData();
                                                });
                                              }
                                            }
                                          }
                                        }),
                                    IconButton(
                                        icon: Icon(Icons.check_circle,
                                            color: Colors.greenAccent),
                                        onPressed: () async {
                                          Object patientObj = {
                                            "name":
                                                phaseExtra[i].patientFullName,
                                            "age": phaseExtra[i].patientAge,
                                            "phone": phaseExtra[i].patientPhone,
                                            "address":
                                                phaseExtra[i].patientAddress,
                                            "img": phaseExtra[i].imageUrl,
                                            "cronic":
                                                phaseExtra[i].hasCronicPatient,
                                            "vaccinated": true,
                                            "unitid": phaseExtra[i].unitId
                                          };

                                          final response = await DoctorData
                                              .updatePatientById(
                                                  phaseTwo[i].patientId,
                                                  patientObj);

                                          if (response.statusCode == 200) {
                                            final response = await DoctorData
                                                .deletePhaseState(
                                                    phaseTwo[i].id);

                                            if (response.statusCode == 200) {
                                              Alertify(
                                                      context: context,
                                                      isDismissible: true,
                                                      alertType:
                                                          AlertifyType.success,
                                                      title: 'Başarılı',
                                                      buttonText: 'OK',
                                                      animationType:
                                                          AnimationType
                                                              .bottomToTop,
                                                      content:
                                                          "Aşılanma işlemi tamamlandı.")
                                                  .show();

                                              setState(() {
                                                getData();
                                              });
                                            }
                                          }
                                        }),
                                    IconButton(
                                        icon: Icon(Icons.close,
                                            color: Colors.redAccent),
                                        onPressed: () async {
                                          final response =
                                              await DoctorData.deletePhaseState(
                                                  phaseTwo[i].id);

                                          if (response.statusCode == 200) {
                                            Alertify(
                                                    context: context,
                                                    isDismissible: true,
                                                    alertType:
                                                        AlertifyType.success,
                                                    title: 'Başarılı',
                                                    buttonText: 'OK',
                                                    animationType: AnimationType
                                                        .bottomToTop,
                                                    content:
                                                        "Silme işlemi Başarılı.")
                                                .show();

                                            setState(() {
                                              getData();
                                            });
                                          }
                                        }),
                                  ]),
                                  title: Text(
                                      phaseTwo[i].patientFullName +
                                          " " +
                                          phaseTwo[i].patientAge.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                  subtitle: Text(
                                    "Tarih : " +
                                        phaseTwo[i]
                                            .appointmentDate
                                            .split('T')[0],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                      Expanded(
                        flex: 1,
                        child: DecoratedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: phaseExtra.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                onTap: () {
                                  print("tile clicked");
                                },
                                trailing: Wrap(children: [
                                  IconButton(
                                      icon: Icon(Icons.check_circle,
                                          color: Colors.greenAccent),
                                      onPressed: () async {
                                        Object patientObj = {
                                          "name": phaseExtra[i].patientFullName,
                                          "age": phaseExtra[i].patientAge,
                                          "phone": phaseExtra[i].patientPhone,
                                          "address":
                                              phaseExtra[i].patientAddress,
                                          "img": phaseExtra[i].imageUrl,
                                          "cronic":
                                              phaseExtra[i].hasCronicPatient,
                                          "vaccinated": true,
                                          "unitid": phaseExtra[i].unitId
                                        };

                                        final response =
                                            await DoctorData.updatePatientById(
                                                phaseExtra[i].patientId,
                                                patientObj);

                                        if (response.statusCode == 200) {
                                          final response =
                                              await DoctorData.deletePhaseState(
                                                  phaseExtra[i].id);

                                          if (response.statusCode == 200) {
                                            Alertify(
                                                    context: context,
                                                    isDismissible: true,
                                                    alertType:
                                                        AlertifyType.success,
                                                    title: 'Başarılı',
                                                    buttonText: 'OK',
                                                    animationType: AnimationType
                                                        .bottomToTop,
                                                    content:
                                                        "Aşılanma işlemi tamamlandı.")
                                                .show();

                                            setState(() {
                                              getData();
                                            });
                                          }
                                        }
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.close,
                                          color: Colors.redAccent),
                                      onPressed: () async {
                                        final response =
                                            await DoctorData.deletePhaseState(
                                                phaseExtra[i].id);

                                        if (response.statusCode == 200) {
                                          Alertify(
                                                  context: context,
                                                  isDismissible: true,
                                                  alertType:
                                                      AlertifyType.success,
                                                  title: 'Başarılı',
                                                  buttonText: 'OK',
                                                  animationType:
                                                      AnimationType.bottomToTop,
                                                  content:
                                                      "Silme işlemi Başarılı.")
                                              .show();

                                          setState(() {
                                            getData();
                                          });
                                        }
                                      }),
                                ]),
                                title: Text(
                                    phaseExtra[i].patientFullName +
                                        " " +
                                        phaseExtra[i].patientAge.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                subtitle: Text(
                                  "Tarih : " +
                                      phaseExtra[i]
                                          .appointmentDate
                                          .split('T')[0],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                    ],
                  ),
                ),
              ),
            )
          ]));
    } else {
      return null;
    }
  }

  tilesOfList(List model, int index) {
    if (model[index] is HealthUnitModel) {
      return ListTile(
          onTap: () {
            print("tile clicked");
          },
          trailing: IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: () {}),
          title: Text(model[index].unitName,
              style: TextStyle(color: Colors.white, fontSize: 20)));
    }

    if (model[index] is DoctorModel) {
      return ListTile(
          onTap: () {
            print("tile clicked");
          },
          trailing: IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: () {}),
          title: Text(model[index].doctorFullName,
              style: TextStyle(color: Colors.white, fontSize: 20)));
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
                                  backgroundImage:
                                      NetworkImage(doctor.imageUrl),
                                  radius: 60,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 80),
                                  child: Text(
                                    doctor.doctorFullName,
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
                                            const EdgeInsets.only(right: 5),
                                        child: Text(
                                          "Telefon :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        doctor.doctorPhone,
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
                                            const EdgeInsets.only(right: 5),
                                        child: Text(
                                          "Adres :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        doctor.doctorAddress,
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
                                      "Birim",
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  child: Container(
                                    child: Text(
                                      unit.unitName.length <= 27
                                          ? unit.unitName
                                          : unit.unitName.substring(0, 27),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Text(
                                          "Adres :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        unit.unitAdress.substring(0, 33),
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Expanded(
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
                                        child: Text(
                                          "Faz-1",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              247, 247, 247, 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                ),
                                SizedBox(
                                  height: 130,
                                  child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: phaseOne.length,
                                    itemBuilder: (context, i) {
                                      return ListTile(
                                        onTap: () {
                                          print("tile clicked");
                                        },
                                        trailing: Wrap(children: [
                                          IconButton(
                                              icon: Icon(Icons.check_circle,
                                                  color: Colors.greenAccent),
                                              onPressed: () async {
                                                DateTime newDate =
                                                    DateTime.parse(phaseOne[i]
                                                            .appointmentDate)
                                                        .add(
                                                            Duration(days: 30));
                                                Object appObj = {
                                                  "doctorid":
                                                      phaseOne[i].doctorId,
                                                  "patientid":
                                                      phaseOne[i].patientId,
                                                  "date": newDate
                                                      .toIso8601String()
                                                      .split('.')[0],
                                                  "priority":
                                                      phaseOne[i].priority
                                                };
                                                Object phaseObj = {
                                                  "phase": 2,
                                                  "doctorpatientid": phaseOne[i]
                                                      .doctorPatientId
                                                };
                                                final response =
                                                    await DoctorData
                                                        .deletePhaseState(
                                                            phaseOne[i].id);
                                                if (response.statusCode ==
                                                    200) {
                                                  final response =
                                                      await DoctorData
                                                          .createAppointment(
                                                              appObj);

                                                  if (response.statusCode ==
                                                      200) {
                                                    final response =
                                                        await DoctorData
                                                            .createPhaseState(
                                                                phaseObj);

                                                    if (response.statusCode ==
                                                        200) {
                                                      Alertify(
                                                              context: context,
                                                              isDismissible:
                                                                  true,
                                                              alertType:
                                                                  AlertifyType
                                                                      .success,
                                                              title: 'Başarılı',
                                                              buttonText: 'OK',
                                                              animationType:
                                                                  AnimationType
                                                                      .bottomToTop,
                                                              content:
                                                                  "Faz 1 Başarılı.")
                                                          .show();

                                                      setState(() {
                                                        getData();
                                                      });
                                                    }
                                                  }
                                                }
                                              }),
                                          IconButton(
                                              icon: Icon(Icons.close,
                                                  color: Colors.redAccent),
                                              onPressed: () async {
                                                final response =
                                                    await DoctorData
                                                        .deletePhaseState(
                                                            phaseOne[i].id);

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
                                                              "Silme işlemi Başarılı.")
                                                      .show();

                                                  setState(() {
                                                    getData();
                                                  });
                                                }
                                              }),
                                        ]),
                                        title: Text(
                                            phaseOne[i].patientFullName +
                                                " " +
                                                phaseOne[i]
                                                    .patientAge
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20)),
                                        subtitle: Text(
                                          "Tarih : " +
                                              phaseOne[i]
                                                  .appointmentDate
                                                  .split('T')[0],
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Expanded(
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
                                        child: Text(
                                          "Faz-2",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              247, 247, 247, 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                ),
                                SizedBox(
                                  height: 130,
                                  child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: phaseTwo.length,
                                    itemBuilder: (context, i) {
                                      return ListTile(
                                        onTap: () {
                                          print("tile clicked");
                                        },
                                        trailing: Wrap(children: [
                                          IconButton(
                                              icon: Icon(Icons.skip_next,
                                                  color: Colors.white),
                                              onPressed: () async {
                                                DateTime newDate =
                                                    DateTime.parse(phaseTwo[i]
                                                            .appointmentDate)
                                                        .add(
                                                            Duration(days: 30));
                                                Object appObj = {
                                                  "doctorid":
                                                      phaseTwo[i].doctorId,
                                                  "patientid":
                                                      phaseTwo[i].patientId,
                                                  "date": newDate
                                                      .toIso8601String()
                                                      .split('.')[0],
                                                  "priority":
                                                      phaseTwo[i].priority
                                                };
                                                Object phaseObj = {
                                                  "phase": 3,
                                                  "doctorpatientid": phaseTwo[i]
                                                      .doctorPatientId
                                                };
                                                final response =
                                                    await DoctorData
                                                        .deletePhaseState(
                                                            phaseTwo[i].id);
                                                if (response.statusCode ==
                                                    200) {
                                                  final response =
                                                      await DoctorData
                                                          .createAppointment(
                                                              appObj);

                                                  if (response.statusCode ==
                                                      200) {
                                                    final response =
                                                        await DoctorData
                                                            .createPhaseState(
                                                                phaseObj);

                                                    if (response.statusCode ==
                                                        200) {
                                                      Alertify(
                                                              context: context,
                                                              isDismissible:
                                                                  true,
                                                              alertType:
                                                                  AlertifyType
                                                                      .warning,
                                                              title: 'Başarılı',
                                                              buttonText: 'OK',
                                                              animationType:
                                                                  AnimationType
                                                                      .bottomToTop,
                                                              content:
                                                                  "Ekstra Faza Geçildi.")
                                                          .show();

                                                      setState(() {
                                                        getData();
                                                      });
                                                    }
                                                  }
                                                }
                                              }),
                                          IconButton(
                                              icon: Icon(Icons.check_circle,
                                                  color: Colors.greenAccent),
                                              onPressed: () async {
                                                Object patientObj = {
                                                  "name": phaseTwo[i]
                                                      .patientFullName,
                                                  "age": phaseTwo[i].patientAge,
                                                  "phone":
                                                      phaseTwo[i].patientPhone,
                                                  "address": phaseTwo[i]
                                                      .patientAddress,
                                                  "img": phaseTwo[i].imageUrl,
                                                  "cronic": phaseTwo[i]
                                                      .hasCronicPatient,
                                                  "vaccinated": true,
                                                  "unitid": phaseTwo[i].unitId
                                                };

                                                final response =
                                                    await DoctorData
                                                        .updatePatientById(
                                                            phaseTwo[i]
                                                                .patientId,
                                                            patientObj);

                                                if (response.statusCode ==
                                                    200) {
                                                  final response =
                                                      await DoctorData
                                                          .deletePhaseState(
                                                              phaseTwo[i].id);

                                                  if (response.statusCode ==
                                                      200) {
                                                    Alertify(
                                                            context: context,
                                                            isDismissible: true,
                                                            alertType:
                                                                AlertifyType
                                                                    .warning,
                                                            title: 'Başarılı',
                                                            buttonText: 'OK',
                                                            animationType:
                                                                AnimationType
                                                                    .bottomToTop,
                                                            content:
                                                                "Aşılanma işlemi tamamlandı.")
                                                        .show();

                                                    setState(() {
                                                      getData();
                                                    });
                                                  }
                                                }
                                              }),
                                          IconButton(
                                              icon: Icon(Icons.close,
                                                  color: Colors.redAccent),
                                              onPressed: () async {
                                                final response =
                                                    await DoctorData
                                                        .deletePhaseState(
                                                            phaseTwo[i].id);

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
                                                              "Silme işlemi Başarılı.")
                                                      .show();

                                                  setState(() {
                                                    getData();
                                                  });
                                                }
                                              }),
                                        ]),
                                        title: Text(
                                            phaseTwo[i].patientFullName +
                                                " " +
                                                phaseTwo[i]
                                                    .patientAge
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20)),
                                        subtitle: Text(
                                          "Tarih : " +
                                              phaseTwo[i]
                                                  .appointmentDate
                                                  .split('T')[0],
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
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
                                      child: Text(
                                        "Faz-extra",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromRGBO(247, 247, 247, 0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)))),
                              ),
                              SizedBox(
                                height: 130,
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: phaseExtra.length,
                                  itemBuilder: (context, i) {
                                    return ListTile(
                                      onTap: () {
                                        print("tile clicked");
                                      },
                                      trailing: Wrap(children: [
                                        IconButton(
                                            icon: Icon(Icons.check_circle,
                                                color: Colors.greenAccent),
                                            onPressed: () async {
                                              Object patientObj = {
                                                "name": phaseExtra[i]
                                                    .patientFullName,
                                                "age": phaseExtra[i].patientAge,
                                                "phone":
                                                    phaseExtra[i].patientPhone,
                                                "address": phaseExtra[i]
                                                    .patientAddress,
                                                "img": phaseExtra[i].imageUrl,
                                                "cronic": phaseExtra[i]
                                                    .hasCronicPatient,
                                                "vaccinated": true,
                                                "unitid": phaseExtra[i].unitId
                                              };

                                              final response = await DoctorData
                                                  .updatePatientById(
                                                      phaseExtra[i].patientId,
                                                      patientObj);

                                              if (response.statusCode == 200) {
                                                final response =
                                                    await DoctorData
                                                        .deletePhaseState(
                                                            phaseExtra[i].id);

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
                                                              "Aşılanma işlemi tamamlandı.")
                                                      .show();

                                                  setState(() {
                                                    getData();
                                                  });
                                                }
                                              }
                                            }),
                                        IconButton(
                                            icon: Icon(Icons.close,
                                                color: Colors.redAccent),
                                            onPressed: () async {
                                              final response = await DoctorData
                                                  .deletePhaseState(
                                                      phaseExtra[i].id);

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
                                                            "Silme işlemi Başarılı.")
                                                    .show();

                                                setState(() {
                                                  getData();
                                                });
                                              }
                                            }),
                                      ]),
                                      title: Text(
                                          phaseExtra[i].patientFullName +
                                              " " +
                                              phaseExtra[i]
                                                  .patientAge
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                      subtitle: Text(
                                        "Tarih : " +
                                            phaseExtra[i]
                                                .appointmentDate
                                                .split('T')[0],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
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
    } else {
      return null;
    }
  }
}

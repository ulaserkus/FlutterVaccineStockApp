import 'package:alertify/alertify.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stock_app/data/ProducerData.dart';
import 'package:flutter_stock_app/models/ClaimModel.dart';
import 'package:flutter_stock_app/models/MinistaryModel.dart';
import 'package:flutter_stock_app/models/ProducerModel.dart';
import 'package:flutter_stock_app/models/ProducerStockModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jwt_decode/jwt_decode.dart';

// ignore: must_be_immutable
class ProducerPanel extends StatefulWidget {
  bool openMenu;
  ProducerPanel({this.openMenu});
  @override
  State<StatefulWidget> createState() {
    return ProducerPanelState();
  }
}

class ProducerPanelState extends State<ProducerPanel> {
  int selectedIndex = 0;
  bool loading = false;
  int producerId = 0;
  ProducerModel producer;
  List<ClaimModel> claims;
  List<ProducerStockModel> stocks;
  List<MinistaryModel> ministaries;
  final storage = new FlutterSecureStorage();
  List<ClaimModel> selectedClaims;
  ClaimModel selectedClaimCount;
  MinistaryModel selectedMinistary;

  @override
  void initState() {
    super.initState();
    getProducerId();
  }

  getProducerId() async {
    var key = await storage.read(key: "token");
    var userObj = Jwt.parseJwt(key);
    this.producerId = userObj["producer_id"];

    print(producerId);
    getData();
  }

  getData() async {
    producer = await ProducerData.getProducerById(this.producerId);
    claims = await ProducerData.getClaimsByProducerId(this.producerId);
    stocks = await ProducerData.getStocksByProducerId(this.producerId);
    ministaries = await ProducerData.getMinistaryList(this.producerId);
    selectedMinistary = ministaries.first;
    selectedClaims = this
        .claims
        .where((element) => element.ministaryId == selectedMinistary.id)
        .toList();

    selectedClaimCount = selectedClaims.first;

    print(producer);
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
                                    icon: FaIcon(FontAwesomeIcons.layerGroup),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.layerGroup,
                                      color: Colors.white,
                                    ),
                                    label: Text("Talepler")),
                                NavigationRailDestination(
                                    icon: FaIcon(FontAwesomeIcons.dollyFlatbed),
                                    selectedIcon: FaIcon(
                                      FontAwesomeIcons.dollyFlatbed,
                                      color: Colors.white,
                                    ),
                                    label: Text("Stok")),
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
                                      NetworkImage(producer.imageUrl),
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
                                    producer.producerName.length >= 10
                                        ? producer.producerName.substring(0, 7)
                                        : producer.producerName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40.0, left: 10),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Text(
                                          "Ülke :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        producer.producerCountry,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 10),
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
                                        producer.producerPhone,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 10),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Text(
                                          "Email :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        producer.producerEmail,
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
                      itemCount: claims.length,
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
                                    await ProducerData.deleteClaimById(
                                        claims[i].id);

                                if (response.statusCode == 200) {
                                  Alertify(
                                          context: context,
                                          content: "Talep Reddedildi.",
                                          isDismissible: true,
                                          alertType: AlertifyType.warning,
                                          buttonText: 'OK',
                                          title: 'Dikkat',
                                          animationType:
                                              AnimationType.bottomToTop)
                                      .show();

                                  setState(() {
                                    getData();
                                  });
                                }
                              }),
                          title: Text(
                              claims[i].ministaryCountry +
                                  "/" +
                                  claims[i].date.split('T')[0],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          subtitle: Text(
                            "Miktar : " + claims[i].vaccineCount.toString(),
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
                            itemCount: stocks.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                onTap: () {
                                  print("tile clicked");
                                },
                                trailing: IconButton(
                                    icon: Icon(Icons.send_sharp,
                                        color: Colors.greenAccent),
                                    onPressed: () {
                                      showSendStockModal(context, stocks[i]);
                                    }),
                                title: Text(stocks[i].vaccineName,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                subtitle: Text(
                                  "Miktar : " +
                                      stocks[i].vaccineCount.toString(),
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
                                      NetworkImage(producer.imageUrl),
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
                                    producer.producerName.length >= 10
                                        ? producer.producerName.substring(0, 7)
                                        : producer.producerName,
                                    textAlign: TextAlign.center,
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
                                          "Ülke :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        producer.producerCountry,
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
                                        producer.producerPhone,
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
                                          "Email :",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Text(
                                        producer.producerEmail,
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
                              child: Text(
                                "Talepler",
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 170,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: claims.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              onTap: () {
                                print("tile clicked");
                              },
                              trailing: Wrap(children: [
                                IconButton(
                                    icon: Icon(Icons.delete_forever,
                                        color: Colors.redAccent),
                                    onPressed: () async {
                                      final response =
                                          await ProducerData.deleteClaimById(
                                              claims[i].id);

                                      if (response.statusCode == 200) {
                                        Alertify(
                                                context: context,
                                                content: "Talep Reddedildi.",
                                                isDismissible: true,
                                                alertType: AlertifyType.warning,
                                                buttonText: 'OK',
                                                title: 'Dikkat',
                                                animationType:
                                                    AnimationType.bottomToTop)
                                            .show();

                                        setState(() {
                                          getData();
                                        });
                                      }
                                    }),
                                IconButton(
                                    icon: Icon(Icons.last_page,
                                        color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = 2;
                                      });
                                    }),
                              ]),
                              title: Text(
                                  claims[i].ministaryCountry +
                                      "/" +
                                      claims[i].date.split('T')[0],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              subtitle: Text(
                                "Miktar : " + claims[i].vaccineCount.toString(),
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
                                              "Stoklar",
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
                                              child: Text(
                                                "Stok EKle",
                                              ),
                                              onPressed: () {
                                                showAddStockModal(context);
                                              },
                                            ),
                                          ),
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
                                  itemCount: stocks.length,
                                  itemBuilder: (context, i) {
                                    return ListTile(
                                      onTap: () {
                                        print("tile clicked");
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            stocks[i].imageUrl,
                                            scale: 1),
                                      ),
                                      trailing: IconButton(
                                          icon: Icon(Icons.send,
                                              color: Colors.greenAccent),
                                          onPressed: () {
                                            showSendStockModal(
                                                context, stocks[i]);
                                          }),
                                      title: Text(stocks[i].vaccineName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
                                      subtitle: Text(
                                        "Miktar : " +
                                            stocks[i].vaccineCount.toString(),
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

  showAddStockModal(context) async {
    final formKey = GlobalKey<FormState>();
    final vaccineName = TextEditingController();
    final vaccineCount = TextEditingController();
    final vaccineImg = TextEditingController();

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
                                  "Stok Ekle",
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
                                          controller: vaccineName,
                                          decoration: InputDecoration(
                                            labelText: "Aşı Adı",
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
                                          controller: vaccineCount,
                                          decoration: InputDecoration(
                                            labelText: "Aşı Miktarı",
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
                                            Pattern pattern = r'^[0-9]*$';

                                            RegExp regex = new RegExp(pattern);

                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Değer giriniz';
                                            }
                                            if (!regex.hasMatch(value)) {
                                              return 'Sayı giriniz';
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
                                          controller: vaccineImg,
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
                                              DateTime today = DateTime.parse(
                                                  DateTime.now().toString());
                                              Object stockObj = {
                                                "name": vaccineName.text,
                                                "count": vaccineCount.text,
                                                "date": today
                                                    .toIso8601String()
                                                    .split('.')[0],
                                                "producerid": producerId,
                                                "img": vaccineImg.text
                                              };
                                              final response =
                                                  await ProducerData
                                                      .createStock(stockObj);
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
                                                            "Stok Ekleme Başarılı.")
                                                    .show();

                                                setState(() {
                                                  getData();
                                                });
                                              }
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ))
                        ]))),
              );
            },
          );
        });
  }

  showSendStockModal(context, ProducerStockModel stock) async {
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
                                  "Teslimat",
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
                              child: Column(
                                children: [
                                  BootstrapRow(height: 80, children: [
                                    BootstrapCol(
                                      sizes: 'col-12',
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: SizedBox(
                                          height: 50,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Color.fromRGBO(
                                                        23, 162, 184, 1))),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: DropdownButton(
                                                value: selectedMinistary,
                                                items: this.ministaries.map(
                                                    (MinistaryModel ministary) {
                                                  return DropdownMenuItem(
                                                      value: ministary,
                                                      child: Text(ministary
                                                          .ministaryCountry));
                                                }).toList(),
                                                hint: Text("Ülke Seç"),
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 20,
                                                ),
                                                onChanged: (val) {
                                                  setState(() {
                                                    selectedMinistary = val;
                                                    selectedClaims = this
                                                        .claims
                                                        .where((element) =>
                                                            element
                                                                .ministaryId ==
                                                            selectedMinistary
                                                                .id)
                                                        .toList();
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  BootstrapRow(height: 80, children: [
                                    BootstrapCol(
                                      sizes: 'col-12',
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: SizedBox(
                                          height: 50,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Color.fromRGBO(
                                                        23, 162, 184, 1))),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: DropdownButton(
                                                value: selectedClaimCount,
                                                items: this
                                                    .selectedClaims
                                                    .map((ClaimModel claim) {
                                                  return DropdownMenuItem(
                                                      value: claim,
                                                      child: Text(claim
                                                          .vaccineCount
                                                          .toString()));
                                                }).toList(),
                                                hint: Text("Miktarı Seç"),
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 20,
                                                ),
                                                onChanged: (val) {
                                                  setState(() {
                                                    selectedClaimCount = val;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  BootstrapCol(
                                    sizes: 'col-6',
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Color.fromRGBO(23, 162, 184, 1),
                                            side: BorderSide(
                                              color: Colors.white,
                                            )),
                                        child: Text("Gönder"),
                                        onPressed: () async {
                                          if (stock.vaccineCount >=
                                              selectedClaimCount.vaccineCount) {
                                            Object vaccineStockObj = {
                                              "name": stock.vaccineName,
                                              "date": stock.lastProductionDate,
                                              "count": (stock.vaccineCount -
                                                  selectedClaimCount
                                                      .vaccineCount),
                                              "producerid": stock.producerId,
                                              "img": stock.imageUrl
                                            };
                                            final response = await ProducerData
                                                .updateStockById(
                                                    stock.vaccineId,
                                                    vaccineStockObj);
                                            if (response.statusCode == 200) {
                                              Object ministaryStockObj = {
                                                "ministaryid":
                                                    selectedMinistary.id,
                                                "stockid": stock.id,
                                                "count": selectedClaimCount
                                                    .vaccineCount
                                              };
                                              final response =
                                                  await ProducerData
                                                      .createMinistaryStock(
                                                          ministaryStockObj);

                                              if (response.statusCode == 200) {
                                                ClaimModel claim =
                                                    selectedClaims
                                                        .where((element) =>
                                                            element
                                                                .vaccineCount ==
                                                            selectedClaimCount
                                                                .vaccineCount)
                                                        .first;
                                                final response =
                                                    await ProducerData
                                                        .deleteClaimById(
                                                            claim.id);

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
                                                              "Teslimat Gönderme Başarılı.")
                                                      .show();

                                                  setState(() {
                                                    getData();
                                                  });
                                                }
                                              }
                                            }
                                          }
                                        }),
                                  ),
                                ],
                              ))
                        ]))),
              );
            },
          );
        });
  }
}

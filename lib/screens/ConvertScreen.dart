import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uchet/models/Uchet.dart';
import 'dart:io';
import 'package:uchet/extensions/context_extensions.dart';
// import 'package:uchet/resources/app_text_styles.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Alignment;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uchet/services/uchet_api.dart';
// import 'package:universal_html/html.dart' hide File, Text;

class ConvertScreen extends StatefulWidget {
  // final Uchet uchet;

  // const LiverAddScreen({Key? key, required this.uchet}) : super(key: key);

  @override
  _ConvertScreenState createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  var selectedUser;
  String searchText = "";
  var toAdd = [];
  var newone = [];
  int check = 0;
  var allCheck = [];
  var getFullAdd = [];
  var fullCheck = [];
  var katka = [];
  bool _isChecked = false;
  bool isLoading = false;
  var s;
  // var toAddList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: GestureDetector(
        //   child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.baseColor),
        //   onTap: () => Navigator.of(context).pop(),
        // ),
        backgroundColor: Color(0xff43537d),
        title: Text('Конверт на Excel', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Column(children: [
            StreamBuilder(
                stream: ('searchText' == "")
                    ? UchetService.searchUchets(value: searchText)
                    : UchetService.fetchAllUchets(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Uchet>> snapshot) {
                  if (snapshot.hasError || !snapshot.hasData)
                    return Container(
                      height: context.sizeScreen.height * .8,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  // allCheck = [];
                  if (isLoading) {
                    return Container(
                      height: context.sizeScreen.height * .8,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return SizedBox(
                      height: 350,
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: Text('Все'),
                            value: _isChecked,
                            onChanged: (val) {
                              setState(
                                () {
                                  _isChecked = val!;

                                  if (val == true) {
                                    for (int i = 0; i < allCheck.length; i++) {
                                      allCheck[i] = true;
                                    }
                                  } else {
                                    for (int i = 0; i < allCheck.length; i++) {
                                      allCheck[i] = false;
                                    }
                                  }
                                },
                              );
                            },
                          ),
                          Container(
                            height: 260,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  if (allCheck.length !=
                                      snapshot.data!.length) {
                                    allCheck.add(false);
                                  }
                                  s = snapshot;
                                  return CheckboxListTile(
                                    title: Text(
                                        snapshot.data![index].id.toString()),
                                    value: allCheck[index],
                                    onChanged: (val) {
                                      setState(
                                        () {
                                          if (val == false) {
                                            _isChecked = false;
                                          }
                                          getFullAdd = [];
                                          allCheck[index] = val;
                                        },
                                      );
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                    );
                  }
                }),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    // minimumSize: Size(40, 0),
                    primary: Color(0xff43537d),
                    onPrimary: Colors
                        .white, //specify the color of the button's text and icons as well as the overlay colors used to indicate the hover, focus, and pressed states
                  ),
                  child: Text(
                    'Конвертировать на excel',
                  ),
                  onPressed: () async {
                    final firebase = FirebaseFirestore.instance;

                    int de = 0;
                    int dee = 0;
                    var list = [];
                    var go = [];
                    var fullCovert = [];
                    for (int i = 0; i < allCheck.length; i++) {
                      if (allCheck[i] == true) {
                        go.add(s.data![i].id.toString());
                      }
                    }
                    print('mal');
                    print(go);

                    // print(i.toString() + ' sds');

                    if (go.length > 0) {
                      print('have');
                      setState(() {
                        isLoading = true;
                      });
                      for (int i = 0; i < go.length; i++) {
                        add(go[i].toString());
                        print('goig');
                      }
                      Future.delayed(Duration(seconds: 10), () {
                        if (getFullAdd.length > 0) {
                          _createExcel(getFullAdd);
                        }
                        if (check != 1) {
                          Future.delayed(Duration(seconds: 5), () {
                            if (getFullAdd.length > 0) {
                              _createExcel(getFullAdd);
                              setState(() {
                                check = 0;
                              });
                            } else {
                              Future.delayed(Duration(seconds: 3), () {
                                _createExcel(getFullAdd);

                                setState(() {
                                  check = 0;
                                });
                              });
                            }
                          });
                        }
                      });
                    } else {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Ошибка'),
                                content: Text('Вы не выбирали!'),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text('OK'),
                                      onPressed: () async {
                                        Navigator.pop(context, true);
                                      }),
                                ],
                              ));
                    }
                  }),
            ),
          ]),
        ),
      ),
    );
  }

  add(String current) async {
    final firebase = FirebaseFirestore.instance;
    var local = [];
    firebase.collection('livers').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['uchetId'] == current) {
          firebase
              .collection('livers')
              .doc(doc['id'])
              .get()
              .then((DocumentSnapshot doc) {
            var toGoList = {};

            doc['pokazanie'].forEach(
                (k, v) => toGoList.addAll({k.toString(): v.toString()}));

            var goTo = {
              "counter": doc["counter"],
              "fullName": doc["fullName"],
              "id": doc["id"],
              "uchetId": doc['uchetId'],
              "pokazanie": toGoList,
            };
            local.add(goTo);
          });
        }
      });
    });
    Future.delayed(Duration(seconds: 10), () {
      getFullAdd.add(local);
    });
  }

  Future<void> _createExcel(var lag) async {
    var how = [];
    // setState(() {
    //   check = 1;
    // });

    final Workbook workbook = Workbook();
    for (int i = 0; i < lag.length; i++) {
      var title = lag[i];
      title = title[0]['uchetId'].toString();
      final Worksheet sheet =
          workbook.worksheets.addWithName('ТП-КТП =' + title);
      sheet.getRangeByName('A1').setText('Имя');
      sheet.getRangeByName('B1').setText('Айди');
      sheet.getRangeByName('C1').setText('Номер счетчика');
      sheet.getRangeByName('D1').setText('Начальная показания');
      sheet.getRangeByName('E1').setText('Конечная показания');
      sheet.getRangeByName('F1').setText('Разница');
      sheet.getRangeByName('C1').columnWidth = 24;
      sheet.getRangeByName('D1').columnWidth = 24;
      sheet.getRangeByName('E1').columnWidth = 24;
      sheet.getRangeByName('F1').columnWidth = 24;

      sheet.getRangeByName('A1').cellStyle.backColor = '#63ff8d';
      sheet.getRangeByName('B1').cellStyle.backColor = '#26ffdb';
      sheet.getRangeByName('C1').cellStyle.backColor = '#975eff';
      sheet.getRangeByName('D1').cellStyle.backColor = '#26ffdb';
      sheet.getRangeByName('E1').cellStyle.backColor = '#975eff';
      sheet.getRangeByName('F1').cellStyle.backColor = '#63ff8d';
      int san = 2;
      var lags = lag[i];

      for (int s = 0; s < lags.length; s++) {
        // print(s);
        // var llist = lag[s]['pokazanie'].values.toList();
        var mal = lags[s]['pokazanie'];
        // print(lag[s]['fullName']);

        var sortedKeys = mal.keys.toList()..sort();
        var sortedKeyss = mal.keys.toList()..sort();

        sortedKeys.sort((a, b) =>
            a.toString().split('.')[1].compareTo(b.toString().split('.')[1]));
        sortedKeys.sort((a, b) =>
            a.toString().split('.')[2].compareTo(b.toString().split('.')[2]));

        // print(mal);
        // print(mal[sortedKeys[sortedKeys.length - 2]]);
        sheet
            .getRangeByName('A' + (s + san).toString())
            .setText(lags[s]['fullName']);

        sheet.getRangeByName('B' + (s + san).toString()).setText(lags[s]['id']);
        sheet
            .getRangeByName('C' + (s + san).toString())
            .setText(lags[s]['counter']);

        sheet
            .getRangeByName('D' + (s + san).toString())
            .setText(mal[sortedKeys[sortedKeys.length - 2]].toString());

        sheet
            .getRangeByName('E' + (s + san).toString())
            .setText(mal[sortedKeys[sortedKeys.length - 1]].toString());

        var first =
            int.parse(mal[sortedKeys[sortedKeys.length - 2]].toString());
        var second =
            int.parse(mal[sortedKeys[sortedKeys.length - 1]].toString());
        String go = (first - second).toString();
        sheet.getRangeByName('F' + (s + san).toString()).setText(go);

        sheet.getRangeByName('A' + (s + san).toString()).columnWidth = 24;
        sheet.getRangeByName('B' + (s + san).toString()).columnWidth = 15;
        sheet.getRangeByName('C' + (s + san).toString()).columnWidth = 15;

        sheet.getRangeByName('D' + (s + san).toString()).columnWidth = 15;
        sheet.getRangeByName('E' + (s + san).toString()).columnWidth = 15;
        sheet.getRangeByName('F' + (s + san).toString()).columnWidth = 15;
      }

      // sheet.getRangeByName('Учет Айди').setText(lag[i]['uchetId']);
      // print('Warninig');
    }

    final List<int> bytes = workbook.saveAsStream();

    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;

    final String fileName = '$path/Output.xlsx';

    final File file = File(fileName);

    await file.writeAsBytes(bytes, flush: true);
    setState(() {
      isLoading = false;
      check = 1;
    });
    OpenFile.open(fileName);
  }
}

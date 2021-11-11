import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uchet/app_navigator.dart';
import 'package:uchet/extensions/context_extensions.dart';
import 'package:uchet/models/Liver.dart';
import 'package:uchet/models/LiverOffline.dart';
import 'package:uchet/models/Uchet.dart';
import 'package:uchet/resources/app_colors.dart';
import 'package:uchet/services/liver_api.dart';
import 'package:uchet/services/uchet_api.dart';
import 'package:uchet/widgets/text_fields/searchTextField.dart';

import 'LiverDetailsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = "";
  int ktpindex = 0;
  var allUchet = [];
  var check = 0;
  var checkField = 0;
  var selectedUser;
  bool enableField = true;

  final controllers = <TextEditingController>[];
  var allEdits = [];
  var allFieldB = [];
  var allEditsLast = [];
  var toGetLiver = {};
  var getIdToAdd = [];
  var todayEdit = [];
  var allTryPerson = {};
  bool isLoading = false;
  var globalCheck = 0;
  var s;
  get pathProvider => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'ПС 35/10КВ',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff43537d),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'ТП-КТП',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      StreamBuilder(
                          stream: ('searchText' == "")
                              ? UchetService.searchUchets(value: searchText)
                              : UchetService.fetchAllUchets(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Uchet>> snapshot) {
                            if (snapshot.hasError || !snapshot.hasData)
                              return Container(
                                height: context.sizeScreen.height * .8,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            s = snapshot;
                            globalCheck += 1;
                            return Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                  child: DropdownButton(
                                    hint: Text("ТП-КТП"),
                                    value: selectedUser,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedUser = value;
                                        print(selectedUser);
                                        getIdToAdd = [];
                                        // print(getIdToAdd);
                                        allEditsLast = [];
                                        allFieldB = [];
                                        allEdits = [];
                                        allTryPerson = {};
                                        globalCheck = 0;
                                        // allEditsLast = [];
                                      });
                                    },
                                    items: snapshot.data!.map((user) {
                                      var index = snapshot.data!.indexOf(user);
                                      return DropdownMenuItem(
                                          value: user.id.toString(),
                                          child: Text(user.id.toString() +
                                              '(' +
                                              user.livers!.length.toString() +
                                              'кол )'));
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SearchTextFiled(
                          autofocus: false,
                          hintText: 'Поиск',
                          onChanged: (text) {
                            setState(() {
                              searchText = text;
                            });
                          },
                          onSubmitted: (_) {},
                        ),
                      ),
                      StreamBuilder(
                          stream: (searchText != "" && searchText != null)
                              ? LiverService.searchLivers(
                                  selectedUser.toString(),
                                  value: searchText.toUpperCase())
                              : LiverService.fetchAllLivers(
                                  selectedUser.toString()),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Liver>> snapshot) {
                            if (snapshot.hasError || !snapshot.hasData)
                              return Container(
                                height: context.sizeScreen.height * .8,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );

                            if (isLoading) {
                              return Container(
                                height: context.sizeScreen.height * .8,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            } else {
                              return Column(
                                children: [
                                  ListView.builder(
                                      itemCount: snapshot.data?.length,
                                      scrollDirection: Axis.vertical,
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Liver liver = snapshot.data![index];
                                        final controller;
                                        var all = {
                                          liver.id.toString(): {
                                            'counter': liver.counter,
                                            'fullName': liver.fullName,
                                            'uchetId': liver.uchetId,
                                            'id': liver.id,
                                            'pokazanie': liver.pokazanie,
                                          }
                                        };

                                        if (allEditsLast.length > 0) {
                                          controller = TextEditingController(
                                              text: allEditsLast[index]);
                                        } else {
                                          controller = TextEditingController();
                                        }
                                        allFieldB.add(true);
                                        // print(liver.id);

                                        if (globalCheck == 2) {
                                          allTryPerson.addAll(all);
                                        }

                                        if (allEditsLast.length > 0) {
                                          allEdits = allEditsLast;
                                        } else {
                                          allEdits.add('');
                                        }
                                        return Column(
                                          children: [
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                          AppColors.baseColor,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                ),
                                                child: ListTile(
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Text(
                                                      //   index.toString(),
                                                      //   style: TextStyle(
                                                      //       fontSize: 20),
                                                      // ),
                                                      // SizedBox(
                                                      //   width: 5,
                                                      // ),
                                                      Flexible(
                                                        child: InkWell(
                                                          onTap: () {
                                                            AppNavigator.pushToPage(
                                                                context,
                                                                LiverDetailScreen(
                                                                    liverId: liver
                                                                        .id
                                                                        .toString()));
                                                          },
                                                          child: Text(
                                                            liver.fullName ??
                                                                'Фио Пустой |',
                                                            style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                          "${liver.id != null ? liver.id : '№ Пустой'}",
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 12),
                                                          child: InkWell(
                                                              onDoubleTap: () {
                                                                setState(() {
                                                                  allFieldB[
                                                                          index] =
                                                                      true;
                                                                });
                                                              },
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      3.5,
                                                                  height: 30,
                                                                  child: TextField(
                                                                      keyboardType: TextInputType.number,
                                                                      onChanged: (text) {
                                                                        allEdits[index] =
                                                                            text;
                                                                      },
                                                                      onSubmitted: (tes) {
                                                                        if (tes !=
                                                                            "") {
                                                                          setState(
                                                                              () {
                                                                            allEditsLast =
                                                                                allEdits;

                                                                            allFieldB[index] =
                                                                                false;
                                                                          });
                                                                        }
                                                                        DateTime
                                                                            now =
                                                                            DateTime.now();

                                                                        String
                                                                            convertedDateTime =
                                                                            "${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year.toString().padLeft(2, '0')}";

                                                                        if (liver.pokazanie!.containsKey(convertedDateTime) &&
                                                                            tes !=
                                                                                '') {
                                                                          showDialog(
                                                                              barrierDismissible: false,
                                                                              context: context,
                                                                              builder: (context) => AlertDialog(
                                                                                    title: Text('Обновить значение?'),
                                                                                    content: Text('Сегоднячный значение: ' + liver.pokazanie![convertedDateTime]),
                                                                                    actions: <Widget>[
                                                                                      FlatButton(
                                                                                          onPressed: () {
                                                                                            Navigator.pop(context, true);
                                                                                          },
                                                                                          child: Text('Да')),
                                                                                      FlatButton(
                                                                                          onPressed: () {
                                                                                            setState(() {
                                                                                              allEdits[index] = liver.pokazanie![convertedDateTime];
                                                                                            });

                                                                                            Navigator.of(context).pop('Нет');
                                                                                          },
                                                                                          child: Text('Нет'))
                                                                                    ],
                                                                                  ));
                                                                        }
                                                                      },
                                                                      controller: controller,
                                                                      enabled: allFieldB[index],
                                                                      decoration: new InputDecoration(
                                                                        border: new OutlineInputBorder(
                                                                            borderSide:
                                                                                new BorderSide(color: Colors.teal)),
                                                                      )),
                                                                ),
                                                              ))),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        );
                                      }),
                                  TextButton(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 44,
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          color: Color(0xff043537d),
                                        ),
                                        child: Text(
                                          'Добавить',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () async {
                                        DateTime now = DateTime.now();
                                        String convertedDateTime =
                                            "${now.day.toString()}.${now.month.toString().padLeft(2, '0')}.${now.year.toString().padLeft(2, '0')}";

                                        setState(() {
                                          isLoading = true;
                                        });
                                        final firebase =
                                            FirebaseFirestore.instance;
                                        firebase.settings = Settings(
                                            persistenceEnabled: true,
                                            cacheSizeBytes:
                                                Settings.CACHE_SIZE_UNLIMITED);
                                        // var allLiver =
                                        //     await Hive.box<LiverId>(
                                        //         'allLiver');
                                        int check = 0;

                                        int de = 0;

                                        int ll = 0;

                                        var toGoList = {};

                                        // print(allTryPerson);
                                        for (int i = 0;
                                            i < allEdits.length;
                                            i++) {
                                          if (allEdits[i].length > 0) {
                                            ll += 1;
                                          }
                                        }
                                        if (ll != 0) {
                                          allTryPerson.forEach((key, value) {
                                            value['pokazanie'].forEach((k, v) =>
                                                toGoList.addAll({
                                                  k.toString(): v.toString()
                                                }));
                                            de += 1;
                                            if (allEdits[de - 1].toString() !=
                                                '') {
                                              toGoList.addAll({
                                                convertedDateTime:
                                                    allEdits[de - 1].toString()
                                              });
                                            }
                                            var goTo = {
                                              "counter": value["counter"],
                                              "fullName": value["fullName"],
                                              "id": value["id"],
                                              "uchetId": value['uchetId'],
                                              "pokazanie": toGoList,
                                            };
                                            Person liverId = Person(
                                              counter: value["counter"],
                                              fullName: value["fullName"],
                                              id: value["id"],
                                              uchetId: value['uchetId'],
                                              pokazanie: toGoList,
                                            );
                                            toGoList = {};
                                            LiverService().updateLiverOffline(
                                                goTo, key, liverId);
                                          });
                                          setState(() {
                                            isLoading = false;
                                            allTryPerson = {};
                                            globalCheck = 0;
                                            allEdits = [];
                                          });
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text('Успешно'),
                                                    content: Text(
                                                        'Успешно добавилась '),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          child: Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(null);
                                                          }),
                                                    ],
                                                  ));
                                        } else {
                                          setState(() {
                                            allEdits = [];
                                            isLoading = false;
                                            allTryPerson = {};
                                            globalCheck = 0;
                                          });
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text('Ошибка'),
                                                    content: Text(
                                                        'Вы не добавили значение!'),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          child: Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(null);
                                                          }),
                                                    ],
                                                  ));
                                        }

                                        // LiverService().updateLiverOffline(
                                        //     goTo, doc['id']);

                                        // var todoBox = await Hive
                                        //     .box<Person>(
                                        //         doc['id']);
                                        // var getted = [];

                                        // todoBox.add(Person(
                                        //     counter:
                                        //         doc["counter"],
                                        //     fullName:
                                        //         doc["fullName"],
                                        //     id: doc["id"],
                                        //     uchetId:
                                        //         doc["uchetId"],
                                        //     pokazanie: toGoList));
                                        // });
                                      }),
                                ],
                              );
                            }
                          }),
                    ]))));
  }
}

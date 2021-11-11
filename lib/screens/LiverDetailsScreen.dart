import 'package:flutter/material.dart';
import 'package:uchet/app_navigator.dart';
import 'package:uchet/extensions/context_extensions.dart';
import 'package:uchet/models/Liver.dart';
import 'package:uchet/models/Uchet.dart';
import 'package:uchet/resources/app_colors.dart';
import 'package:uchet/resources/app_text_styles.dart';
import 'package:uchet/screens/LiverScreen.dart';
import 'package:uchet/services/liver_api.dart';
import 'package:uchet/services/uchet_api.dart';
import 'package:uchet/widgets/list/uchet_item.dart';
import 'package:uchet/widgets/text_fields/searchTextField.dart';

class LiverDetailScreen extends StatefulWidget {
  final String liverId;
  const LiverDetailScreen({Key? key, required this.liverId}) : super(key: key);

  @override
  _LiverDetailScreenState createState() => _LiverDetailScreenState();
}

class _LiverDetailScreenState extends State<LiverDetailScreen> {
  String searchText = "";
  String raznica = 'Неизвестно';

  TextEditingController yourControllerName = new TextEditingController();

  changeText(text) {
    setState(() {
      raznica = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff43537d),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Информация о жителя',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream: LiverService().fetchSingleLiver(widget.liverId),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Liver>> snapshot) {
                    if (snapshot.hasError || !snapshot.hasData)
                      return Container(
                        height: context.sizeScreen.height * .8,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    Liver liver = snapshot.data![0];

                    int countPokaz =
                        int.parse(liver.pokazanie!.length.toString());
                    String lastPokazDay =
                        liver.pokazanie!.keys.elementAt(countPokaz - 1);
                    String lastPokazStr = liver.pokazanie![lastPokazDay];
                    var mal = liver.pokazanie!;
                    var sortedKeys = mal.keys.toList()..sort();
                    int lastPokazInt =
                        int.parse(liver.pokazanie![lastPokazDay]);
                    Map<String, String> toGoList = {};
                    liver.pokazanie!.forEach((k, v) =>
                        toGoList.addAll({k.toString(): v.toString()}));

                    return Column(
                      children: [
                        info('Имя', liver.fullName.toString()),
                        info('Лицевой счет', liver.id.toString()),
                        info('№ счетчика', liver.counter.toString()),
                        info('Начальная показание',
                            sortedKeys[sortedKeys.length - 1]),
                        Padding(
                          child: Text(
                            mal[sortedKeys[sortedKeys.length - 1]],
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          padding: EdgeInsets.only(top: 10),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text('Конечная показание',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: TextField(
                                  controller: yourControllerName,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hoverColor: Colors.black,
                                      hintText: 'Показание'),
                                ),
                                width: 150,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: TextButton(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 44,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Color(0xff043537d),
                                    ),
                                    child: Text(
                                      'Добавить',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {
                                    int posledniy = int.parse(
                                      yourControllerName.text.toString(),
                                    );
                                    String posPokaz = posledniy.toString();
                                    DateTime now = DateTime.now();

                                    String convertedDateTime =
                                        "${now.day.toString()}.${now.month.toString().padLeft(2, '0')}.${now.year.toString().padLeft(2, '0')}";

                                    int razn = lastPokazInt - posledniy;
                                    changeText(razn.toString());
                                    toGoList
                                        .addAll({convertedDateTime: posPokaz});
                                    var allThing = {
                                      "counter": liver.counter,
                                      "fullName": liver.fullName,
                                      "id": liver.id,
                                      "uchetId": liver.uchetId,
                                      "pokazanie": toGoList,
                                    };
                                    LiverService().updateLiver(
                                        allThing, widget.liverId.toString());
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        info('Разница', '$raznica'),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Text('Конечная показание',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: TextField(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hoverColor: Colors.black,
                                      hintText: 'Проверка ПКУ'),
                                ),
                                width: 150,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: TextButton(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 44,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      color: Color(0xff043537d),
                                    ),
                                    child: Text(
                                      'Добавить',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  info(title, text) {
    return Column(
      children: [
        Padding(
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          padding: EdgeInsets.only(top: 23),
        ),
        Padding(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          padding: EdgeInsets.only(top: 10),
        ),
      ],
    );
  }
}

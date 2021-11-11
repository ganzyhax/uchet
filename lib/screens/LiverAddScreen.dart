import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uchet/extensions/context_extensions.dart';
import 'package:uchet/models/Liver.dart';
import 'package:uchet/models/Uchet.dart';
import 'package:uchet/resources/app_colors.dart';
import 'package:uchet/resources/app_text_styles.dart';
import 'package:uchet/screens/LiverDetailsScreen.dart';
import 'package:uchet/services/liver_api.dart';
import 'package:uchet/services/uchet_api.dart';
import 'package:uchet/widgets/list/liver_item.dart';
import 'package:uchet/widgets/text_fields/searchTextField.dart';
import 'package:file_picker/file_picker.dart';
import '../app_navigator.dart';
import 'package:hive/hive.dart';

class LiverAddScreen extends StatefulWidget {
  // final Uchet uchet;

  // const LiverAddScreen({Key? key, required this.uchet}) : super(key: key);

  @override
  _LiverAddScreenState createState() => _LiverAddScreenState();
}

class _LiverAddScreenState extends State<LiverAddScreen> {
  String searchText = "";
  String _name = '';
  String _email = '';
  String _password = '';
  String _url = '';
  String _phoneNumber = '';
  String _calories = '';

  TextEditingController controllName = new TextEditingController();
  TextEditingController controllLS = new TextEditingController();
  TextEditingController numberSchet = new TextEditingController();
  String mestoUchet = '0';
  var selectedUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Имя', labelStyle: TextStyle(color: Colors.black)),
        controller: controllName,
      ),
    );
  }

  Widget _buildEmail() {
    return Container(
      child: TextFormField(
        controller: controllLS,
        decoration: InputDecoration(
            labelText: 'Лицевой счет',
            labelStyle: TextStyle(color: Colors.black)),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      child: TextFormField(
        controller: numberSchet,
        decoration: InputDecoration(
            labelText: 'Номер счетчика',
            labelStyle: TextStyle(color: Colors.black)),
        keyboardType: TextInputType.number,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить жителя ',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Color(0xff43537d),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text(
                //   'Добавить нового жителя',
                //   style: TextStyle(fontSize: 20),
                // ),
                // _buildName(),
                // _buildEmail(),
                // _buildPassword(),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Имя',
                        labelStyle: TextStyle(color: Colors.black)),
                    controller: controllName,
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: controllLS,
                    decoration: InputDecoration(
                        labelText: 'Лицевой счет',
                        labelStyle: TextStyle(color: Colors.black)),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: numberSchet,
                    decoration: InputDecoration(
                        labelText: 'Номер счетчика',
                        labelStyle: TextStyle(color: Colors.black)),
                    keyboardType: TextInputType.number,
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
                          child: Center(child: CircularProgressIndicator()),
                        );
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

                                  // allEditsLast = [];
                                });
                              },
                              items: snapshot.data!.map((user) {
                                return DropdownMenuItem(
                                    value: user.id.toString(),
                                    child: Text(user.id.toString()));
                              }).toList(),
                            ),
                          )
                        ],
                      );
                    }),
                // _builURL(),
                // _buildPhoneNumber(),
                // _buildCalories(),

                // SizedBox(height: 100),
                RaisedButton(
                  color: Color(0xff43537d),
                  child: Text(
                    'Добавить',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    final Map<String, String> someMap = {
                      "02.02.2021": '0',
                    };
                    var listaProcura = [];
                    String temp = "";
                    for (var i = 0;
                        i < controllName.text.toString().length;
                        i++) {
                      temp =
                          temp + controllName.text.toString()[i].toUpperCase();
                      listaProcura.add(temp);
                    }
                    var allThing = {
                      "counter": numberSchet.text.toString(),
                      "fullName": controllName.text.toString(),
                      "id": controllLS.text.toString(),
                      "uchetId": selectedUser.toString(),
                      "pokazanie": someMap,
                      "searchKeyword": listaProcura,
                    };
                    if (selectedUser != null &&
                        controllName.text.toString().length > 1 &&
                        numberSchet.text.toString().length >= 1 &&
                        controllLS.text.toString().length >= 0) {
                      var firebase = FirebaseFirestore.instance;
                      firebase
                          .collection('uchet')
                          .where('id', isEqualTo: selectedUser)
                          .get()
                          .then((QuerySnapshot snapshot) {
                        snapshot.docs.forEach((doc) {
                          var allHave = doc['livers'];

                          allHave.add(controllLS.text.toString());
                          var updateUchet = {
                            'id': selectedUser.toString(),
                            'livers': allHave,
                          };
                          print('addda');
                          UchetService().addLiverToList(
                              updateUchet, selectedUser.toString());

                          LiverService()
                              .addLiver(allThing, controllLS.text.toString());
                        });
                      });
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Успешно'),
                                content: Text('Успешно добавилась '),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text('OK'),
                                      onPressed: () async {
                                        setState(() {
                                          controllName.text = '';
                                          numberSchet.text = '';
                                          controllLS.text = '';
                                          selectedUser = null;
                                        });
                                        Navigator.pop(context, true);
                                      }),
                                ],
                              ));
                    } else {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Ошибка'),
                                content: Text('Не все поля заполнены!'),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text('OK'),
                                      onPressed: () async {
                                        Navigator.pop(context, true);
                                      }),
                                ],
                              ));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

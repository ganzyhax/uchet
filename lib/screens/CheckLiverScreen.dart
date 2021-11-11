import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uchet/app_navigator.dart';
import 'package:uchet/extensions/context_extensions.dart';
import 'package:uchet/models/Liver.dart';
import 'package:uchet/models/Uchet.dart';
import 'package:uchet/resources/app_text_styles.dart';
import 'package:uchet/screens/LiverScreen.dart';
import 'package:uchet/services/liver_api.dart';
import 'package:uchet/services/uchet_api.dart';
import 'package:uchet/widgets/list/liver_item.dart';
import 'package:uchet/widgets/list/uchet_item.dart';
import 'package:uchet/widgets/tabview.dart';
import 'package:uchet/widgets/text_fields/searchTextField.dart';

import 'LiverDetailsScreen.dart';

class CheckLiverScreen extends StatefulWidget {
  const CheckLiverScreen({Key? key}) : super(key: key);

  @override
  _CheckLiverScreenState createState() => _CheckLiverScreenState();
}

class _CheckLiverScreenState extends State<CheckLiverScreen> {
  String searchText = "";
  int ktpindex = 0;
  var allUchet = [];
  var check = 0;
  var selectedUser;
  bool enableField = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'ПС 35/10КВ',
            style: AppTextStyles.blackBigBoldText,
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ТП-КТП',
                        style: AppTextStyles.blackSmallBoldText,
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

                            // for (int i = 0; i < snapshot.data!.length; i++) {
                            //   while (check != snapshot.data!.length)
                            //     print(snapshot.data![i].id);
                            //   allUchet.add(snapshot.data![i].id);
                            //   check += 1;
                            // }
                            // var ascending = allUchet..sort();
                            // print(ascending);
                            return Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                  child: DropdownButton(
                                    hint: Text("Select item"),
                                    value: selectedUser,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedUser = value;
                                      });
                                    },
                                    items: snapshot.data!.map((user) {
                                      return DropdownMenuItem(
                                          value: user.id.toString(),
                                          child: Text(user.id.toString()));
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
                                  value: searchText)
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

                            return ListView.builder(
                                itemCount: snapshot.data?.length,
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  Liver liver = snapshot.data![index];
                                  return LiverItem(
                                    index: index,
                                    liver: liver,
                                    enableField: enableField,
                                    onPressed: () => AppNavigator.pushToPage(
                                        context,
                                        LiverDetailScreen(liverId: liver.id!)),
                                  );
                                });
                          })
                    ]))));
  }
}

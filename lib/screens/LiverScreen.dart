import 'package:flutter/material.dart';
import 'package:uchet/extensions/context_extensions.dart';
import 'package:uchet/models/Liver.dart';
import 'package:uchet/models/Uchet.dart';
import 'package:uchet/resources/app_colors.dart';
import 'package:uchet/resources/app_text_styles.dart';
import 'package:uchet/screens/LiverDetailsScreen.dart';
import 'package:uchet/screens/LiverAddScreen.dart';
import 'package:uchet/services/liver_api.dart';
import 'package:uchet/widgets/list/liver_item.dart';
import 'package:uchet/widgets/text_fields/searchTextField.dart';

import '../app_navigator.dart';

class LiversScreen extends StatefulWidget {
  final Uchet uchet;

  const LiversScreen({Key? key, required this.uchet}) : super(key: key);

  @override
  _LiversScreenState createState() => _LiversScreenState();
}

class _LiversScreenState extends State<LiversScreen> {
  String searchText = "";
  bool enableField = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => AppNavigator.pushToPage(
            context,
            LiverAddScreen(
                // uchet: widget.uchet,
                )),
      ),
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.baseColor),
          onTap: () => Navigator.of(context).pop(),
        ),
        title: Text('Жители', style: AppTextStyles.blackBigBoldText),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SearchTextFiled(
                  autofocus: false,
                  hintText: 'Искать жителей',
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
                      ? LiverService.searchLivers(widget.uchet.id!,
                          value: searchText)
                      : LiverService.fetchAllLivers(widget.uchet.id!),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Liver>> snapshot) {
                    if (snapshot.hasError || !snapshot.hasData)
                      return Container(
                        height: context.sizeScreen.height * .8,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          Liver liver = snapshot.data![index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.baseColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListTile(
                              // onTap: () => onPressed.call(),
                              title: Row(
                                children: [
                                  Text(liver.fullName ?? 'Фио Пустой |',
                                      style: AppTextStyles.blackBoldText),
                                  SizedBox(width: 5),
                                  Text(
                                      "${liver.id != null ? liver.id : '№ Пустой'}",
                                      style: AppTextStyles.blackBoldText),
                                  Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Container(
                                        width: 100.0,
                                        height: 30,
                                        child: TextField(
                                            onChanged: (text) {
                                              // enableField = false;
                                            },
                                            enabled: enableField,
                                            decoration: new InputDecoration(
                                              border: new OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors.teal)),
                                            )),
                                      )),
                                ],
                              ),
                            ),
                          );
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}

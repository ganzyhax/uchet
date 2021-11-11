import 'package:flutter/material.dart';
import 'package:uchet/models/Liver.dart';
import 'package:uchet/resources/app_colors.dart';
import 'package:uchet/resources/app_text_styles.dart';

class LiverItem extends StatelessWidget {
  final int index;
  final Liver liver;
  final VoidCallback onPressed;
  final bool enableField;
  const LiverItem({
    Key? key,
    required this.index,
    required this.liver,
    required this.onPressed,
    required this.enableField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.baseColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: ListTile(
        onTap: () => onPressed.call(),
        title: Row(
          children: [
            Text(liver.fullName ?? 'Фио Пустой |',
                style: AppTextStyles.blackBoldText),
            SizedBox(width: 5),
            Text("${liver.id != null ? liver.id : '№ Пустой'}",
                style: AppTextStyles.blackBoldText),
            Padding(
                padding: EdgeInsets.only(left: 20),
                child: Container(
                  width: 100,
                  height: 30,
                  child: TextField(
                      onChanged: (text) {
                        // enableField = false;
                      },
                      enabled: enableField,
                      decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                      )),
                )),
          ],
        ),
      ),
    );
  }
}

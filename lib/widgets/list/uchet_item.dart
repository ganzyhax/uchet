import 'package:flutter/material.dart';
import 'package:uchet/models/Uchet.dart';
import 'package:uchet/resources/app_colors.dart';
import 'package:uchet/resources/app_text_styles.dart';

class UchetItem extends StatelessWidget {
  final int index;
  final Uchet uchet;
  final VoidCallback onPressed;

  const UchetItem({
    Key? key,
    required this.index,
    required this.uchet,
    required this.onPressed,
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
            SizedBox(width: 5),
            Text("${uchet.id} (кол.аб ${uchet.livers?.length})",
                style: AppTextStyles.blackBoldText),
          ],
        ),
      ),
    );
  }
}

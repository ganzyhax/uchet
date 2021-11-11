import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uchet/resources/app_colors.dart';

class SearchTextFiled extends StatefulWidget {
  final bool? autofocus;
  final String? hintText;
  final Function(String)? onChanged;
  final VoidCallback? onClearIcon;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;

  const SearchTextFiled({
    this.autofocus,
    this.hintText,
    this.onChanged,
    this.onClearIcon,
    this.onSubmitted,
    this.keyboardType,
    Key? key,
  }) : super(key: key);

  @override
  _SearchTextFiledState createState() => _SearchTextFiledState();
}

class _SearchTextFiledState extends State<SearchTextFiled> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      autofocus: widget.autofocus ?? false,
      onChanged: (value) => _onChanged(value),
      keyboardType: widget.keyboardType,
      onFieldSubmitted: widget.onSubmitted,
      cursorColor: AppColors.baseColor,
      showCursor: true,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, size: 24,color: AppColors.baseColor),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              width: 2,
              color: AppColors.baseColor,
            )),
        isDense: true,
        hintText: widget.hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              width: 2,
              color: AppColors.baseColor,
            )),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: false,
        focusColor: AppColors.baseColor,
      ),
    );
  }

  _onChanged(String value) {
    setState(() {
      widget.onChanged!(value);
    });
  }
}

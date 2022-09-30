import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';
import 'package:m2pcarddetails/utils/font.dart';

class PlainTextField extends StatefulWidget {
  String hintText;
  bool obscureText;
  TextEditingController controller;
  Widget? suffixWidget;
  bool isEnable;
  bool isReadOnly;
  Function? onTapped;
  Widget? prefixWidget;
  TextInputType keyBoardType;
  int? maximumWordCount;
  Color titleColor;
  Color borderColor;
  Color textColor;
  bool isHighlighted;
  Color highlightColor;
  FocusNode? focusNode;
  Color? focusTextColor;
  bool isCopyEnabled;
  Function? onchanged;

  // ignore: avoid_unused_constructor_parameters

  PlainTextField(
      // ignore: invalid_required_positional_param

      // ignore: invalid_required_positional_param
      @required this.hintText,
      // ignore: invalid_required_positional_param
      @required this.controller,
      {this.obscureText = false,
      this.suffixWidget,
      this.prefixWidget,
      this.isEnable = true,
      this.onTapped,
      this.isReadOnly = false,
      this.maximumWordCount,
      this.titleColor = ColorResource.color1515151,
      this.textColor = ColorResource.color1515151,
      this.borderColor = ColorResource.colorb9b9bf,
      this.isHighlighted = false,
      this.highlightColor = ColorResource.colorf5f5f7,
      this.focusNode,
      this.focusTextColor,
      this.keyBoardType = TextInputType.name,
      this.onchanged,
      this.isCopyEnabled = false});

  @override
  _PlainTextFieldState createState() => _PlainTextFieldState();
}

class _PlainTextFieldState extends State<PlainTextField> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: widget.borderColor,
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.borderColor,
            )),
        child: TextField(
          textInputAction: TextInputAction.done,
          onTap: () {
            if (widget.onTapped != null) widget.onTapped!();
          },
          onChanged: (v) {
            if (widget.onchanged != null) widget.onchanged!();
          },

          inputFormatters: [
            if (widget.maximumWordCount != null)
              LengthLimitingTextInputFormatter(widget.maximumWordCount),
          ],
          onSubmitted: (t) {
            // widget.focusNode.unfocus();
            // FocusScope.of(context).requestFocus(widget.focusNode);
            // print('completed');
          },
          autocorrect: false,
          enableSuggestions: false,
          obscureText: widget.obscureText,
          controller: widget.controller,
          readOnly: widget.isReadOnly,
          enabled: widget.isEnable,
          keyboardType: widget.keyBoardType,
          maxLines: 1,

          // focusNode: widget.focusNode,
          style: TextStyle(
              // fontWeight: FontWeights.bold,
              color: (widget.focusNode != null && widget.focusNode!.hasFocus)
                  ? widget.focusTextColor
                  : widget.textColor,
              fontFamily: Font.IlisarniqRegular.toString(),
              fontSize: 12),
          decoration: InputDecoration(
            icon: widget.prefixWidget,
            labelStyle: TextStyle(
              color: widget.titleColor,
              fontSize: 12,
              // fontFamily: Font.poppinsMedium.toString()
            ),
            border: InputBorder.none,
            focusedBorder: widget.isHighlighted
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: widget.highlightColor))
                : InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            isDense: true, // Added this
            contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: widget.prefixWidget != null ? -10 : 16),
            hintText: widget.hintText,
            // prefixIcon: widget.prefixWidget,
            // hintStyle: TextStyle(
            //     color: Colors.red,
            //     fontFamily: Font.poppinsMedium.toString()),
            suffixIcon: widget.suffixWidget != null
                ? UnconstrainedBox(child: widget.suffixWidget)
                : null,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:m2pcarddetails/utils/apputils.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';
import 'package:m2pcarddetails/utils/font.dart';

import 'custom_text.dart';

class PrimaryButton extends StatefulWidget {
  final String buttonName;
  final Function? onClick;
  // ignore: prefer_typing_uninitialized_variables
  final double leftMargin;
  // ignore: type_annotate_public_apis
  final double rightMargin;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;
  final bool isMarginRequired;
  final Color textColor;
  final Color marginColor;
  final bool isShadowrequired;
  final Widget? prefixIcon;

  const PrimaryButton(this.buttonName,
      {this.onClick,
      this.leftMargin = 25,
      this.rightMargin = 25,
      this.color = ColorResource.color4C7DFF,
      this.fontWeight = FontWeight.w700,
      this.fontSize = 12,
      this.isMarginRequired = true,
      this.textColor = Colors.white,
      this.marginColor = ColorResource.color4C7DFF,
      this.prefixIcon,
      this.isShadowrequired = false});
  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: MediaQuery.of(context).size.width,
      decoration: _buildDecoration(),
      child: InkWell(
        onTap: () {
          AppUtils.hideKeyBoard(context);
          if (widget.onClick != null) {
            widget.onClick!();
          }
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: widget.prefixIcon,
                ),
              CustomText(
                widget.buttonName,
                color: widget.textColor,
                font: Font.IlisarniqRegular,
                fontSize: widget.fontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Decoration _buildDecoration() {
    return BoxDecoration(
        // ignore: avoid_redundant_argument_values
        border: widget.isMarginRequired
            // ignore: avoid_redundant_argument_values
            ? Border.all(width: 1, color: widget.marginColor)
            : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          if (widget.isMarginRequired && widget.isShadowrequired)
            const BoxShadow(
                color: ColorResource.color4C7DFF,
                blurRadius: 20,
                offset: Offset(0, 2))
        ],
        // ignore: unnecessary_this
        color: this.widget.color);
  }
}

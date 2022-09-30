import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';
import 'package:m2pcarddetails/utils/font.dart';

import 'custom_text.dart';

class CustomTextField extends StatefulWidget {
  String title;
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

  // ignore: avoid_unused_constructor_parameters

  CustomTextField(
      // ignore: invalid_required_positional_param
      @required this.title,
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
      this.isCopyEnabled = false});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var copyImage =
      new AssetImage('assets/images/copy.png', package: 'm2pcarddetails');

  @override
  void initState() {
    // TODO: implement initState
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(() {
        setState(() {
          FocusScope.of(context).requestFocus(widget.focusNode);
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0, left: 0),
                child: CustomText(
                  widget.title,
                  fontSize: 13,
                  color: widget.titleColor,
                ),
              ),
              if (widget.isCopyEnabled) Spacer(),
              if (widget.isCopyEnabled)
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.controller.text));

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Copied to clipboard",
                        // color: Colors.white,
                      ),
                      action: SnackBarAction(
                        label: 'Okay',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    ));
                  },
                  child: Row(
                    children: [
                      CustomText(
                        "Copy",
                        fontSize: 13,
                        color: ColorResource.color4D7DFF,
                      ),
                      Container(
                        width: 22,
                        height: 22,
                        padding: const EdgeInsets.only(left: 3),
                        child: Image(image: copyImage, fit: BoxFit.cover),
                      )
                    ],
                  ),
                ),
            ],
          ),
          Theme(
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
                    color:
                        (widget.focusNode != null && widget.focusNode!.hasFocus)
                            ? widget.focusTextColor
                            : widget.textColor,
                    fontFamily: Font.IlisarniqRegular.toString(),
                    fontSize: 18),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: widget.titleColor,
                    fontSize: 24,
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                  hintText: widget.hintText,
                  prefixIcon: widget.prefixWidget,
                  // hintStyle: TextStyle(
                  //     color: Colors.red,
                  //     fontFamily: Font.poppinsMedium.toString()),
                  suffixIcon: widget.suffixWidget != null
                      ? UnconstrainedBox(child: widget.suffixWidget)
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('Disposed');
    super.dispose();
  }
}

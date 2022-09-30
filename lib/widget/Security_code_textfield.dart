import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';
import 'package:m2pcarddetails/utils/font.dart';

import 'custom_text.dart';

class SecurityCodeTextField extends StatefulWidget {
  TextEditingController textEditingController;
  bool isObsecureText;
  Function onViewCvvTapped;

  SecurityCodeTextField(
      this.textEditingController, this.isObsecureText, this.onViewCvvTapped);

  @override
  _SecurityCodeTextFieldState createState() => _SecurityCodeTextFieldState();
}

class _SecurityCodeTextFieldState extends State<SecurityCodeTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 9.0, left: 0),
                child: CustomText(
                  "Security Code",
                  fontSize: 13,
                  color: ColorResource.color1515151.withOpacity(0.4),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.red,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorResource.colorf9f9f9
                        // border: Border.all(
                        //   color: ColorResource.colorf9f9f9,
                        // )
                        ),
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.center,
                      onTap: () {},
                      // inputFormatters: [
                      //   MaskedTextInputFormatter(
                      //     mask: 'xxxx-xxxx-xxxx-xxxx',
                      //     separator: '-',
                      //   ),
                      // ],
                      onSubmitted: (t) {
                        // widget.focusNode.unfocus();
                        // FocusScope.of(context).requestFocus(widget.focusNode);
                        // print('completed');
                      },
                      autocorrect: false,
                      enableSuggestions: false,
                      obscureText: widget.isObsecureText,
                      controller: widget.textEditingController,
                      readOnly: true,
                      enabled: false,
                      maxLines: 1,
                      // focusNode: widget.focusNode,
                      style: TextStyle(
                          // fontWeight: FontWeights.bold,
                          color: ColorResource.color1515151,
                          fontFamily: Font.IlisarniqRegular.toString(),
                          letterSpacing: 18.0,
                          fontSize: 18),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: ColorResource.color1515151,
                          fontSize: 24,
                          // fontFamily: Font.poppinsMedium.toString()
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true, // Added this
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 21),
                        hintText: "",
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  widget.onViewCvvTapped();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorResource.color4D7DFF,
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(10),
                  child: CustomText(
                    widget.isObsecureText ? "View CVV" : "Hide CVV",
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

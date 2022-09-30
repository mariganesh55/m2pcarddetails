import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m2pcarddetails/utils/apputils.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';
import 'package:m2pcarddetails/utils/image_resource.dart';
import 'package:m2pcarddetails/utils/validator.dart';
import 'package:m2pcarddetails/widget/plain_textfield.dart';
import 'package:m2pcarddetails/widget/primary_button.dart';

import 'custom_text.dart';

class TransactionLimitWidget extends StatefulWidget {
  String title;
  bool switchValue;
  Function onValueChange;
  Function onSaveTapped;
  Widget image;
  TextEditingController controller;

  TransactionLimitWidget(
    this.title,
    this.switchValue,
    this.onValueChange,
    this.image,
    this.controller,
    this.onSaveTapped,
  );
  @override
  _TransactionLimitWidgetState createState() => _TransactionLimitWidgetState();
}

class _TransactionLimitWidgetState extends State<TransactionLimitWidget>
    with TickerProviderStateMixin {
  bool showTextField = true;

  bool buttonASelected = false;
  bool buttonBSelected = false;
  bool buttonCSelected = false;
  bool buttonDSelected = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.image,
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: CustomText(
                  widget.title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorResource.color1515151.withOpacity(0.8),
                ),
              ),
              Spacer(),
              CupertinoSwitch(
                  value: widget.switchValue,
                  onChanged: (value) {
                    widget.onValueChange(value);
                  })
            ],
          ),
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeIn,
            child: Visibility(
              visible: widget.switchValue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: CustomText(
                      "*Max.Per day Limit  ",
                      fontSize: 10,
                      color: ColorResource.color1515151.withOpacity(0.5),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: showTextField
                              ? PlainTextField(
                                  "Set New Limit",
                                  widget.controller,
                                  onchanged: (text) {
                                    if (text == "2500") {
                                      onButtonAselected();
                                    } else if (text == "5000") {
                                      onButtonBselected();
                                    } else if (text == "10000") {
                                      onButtonCselected();
                                    } else if (text == "20000") {
                                      onButtonDselected();
                                    } else {
                                      alllButtonDeselected();
                                    }
                                  },
                                  prefixWidget: Padding(
                                      padding: EdgeInsets.only(
                                          top: 15, left: 15, bottom: 15),
                                      child: CustomText('₹')),
                                  keyBoardType: TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
                                )
                              : CustomText("₹ " + widget.controller.text)),
                      if (showTextField)
                        Container(
                          width: 92,
                          height: 40,
                          margin: const EdgeInsets.only(left: 12),
                          child: PrimaryButton(
                            "Save",
                            color: ColorResource.colorEBF0FF,
                            textColor: ColorResource.color4C7DFF,
                            isMarginRequired: false,
                            onClick: () {
                              final limitStatus = Validator.validate(
                                  widget.controller.text.trim(),
                                  rules: ['required']);
                              if (!limitStatus.status) {
                                AppUtils.showErrorToast("Limit can't be empty");
                              } else {
                                setState(() {
                                  showTextField = false;
                                });
                              }
                            },
                          ),
                        ),
                      if (!showTextField)
                        Container(
                          width: 92,
                          height: 40,
                          margin: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                child: Image(
                                  image: ImageResource.edit,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: PrimaryButton(
                                  "Edit Limit",
                                  color: Colors.white,
                                  textColor: ColorResource.color4C7DFF,
                                  isMarginRequired: false,
                                  onClick: () {
                                    final limitStatus = Validator.validate(
                                        widget.controller.text.trim(),
                                        rules: ['required']);
                                    if (!limitStatus.status) {
                                      AppUtils.showErrorToast(
                                          "Limit can't be empty");
                                    } else {
                                      setState(() {
                                        showTextField = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                  if (showTextField)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: PrimaryButton(
                              "₹2500",
                              color: buttonASelected
                                  ? ColorResource.color4C7DFF
                                  : Colors.white,
                              textColor: buttonASelected
                                  ? Colors.white
                                  : ColorResource.color4C7DFF,
                              onClick: () {
                                onButtonAselected();
                              },
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: PrimaryButton(
                              "₹5000",
                              color: buttonBSelected
                                  ? ColorResource.color4C7DFF
                                  : Colors.white,
                              textColor: buttonBSelected
                                  ? Colors.white
                                  : ColorResource.color4C7DFF,
                              onClick: () {
                                onButtonBselected();
                              },
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: PrimaryButton(
                              "₹10,000",
                              color: buttonCSelected
                                  ? ColorResource.color4C7DFF
                                  : Colors.white,
                              textColor: buttonCSelected
                                  ? Colors.white
                                  : ColorResource.color4C7DFF,
                              onClick: () {
                                onButtonCselected();
                              },
                            ),
                          )),
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: PrimaryButton(
                              "₹20,000",
                              color: buttonDSelected
                                  ? ColorResource.color4C7DFF
                                  : Colors.white,
                              textColor: buttonDSelected
                                  ? Colors.white
                                  : ColorResource.color4C7DFF,
                              onClick: () {
                                onButtonDselected();
                              },
                            ),
                          )),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onButtonAselected() {
    setState(() {
      buttonDSelected = false;
      buttonASelected = true;
      buttonBSelected = false;
      buttonCSelected = false;
      widget.controller.text = "2500";
    });
    AppUtils.hideKeyBoard(context);
  }

  void onButtonBselected() {
    setState(() {
      buttonDSelected = false;
      buttonASelected = false;
      buttonBSelected = true;
      buttonCSelected = false;
      widget.controller.text = "5000";
    });
    AppUtils.hideKeyBoard(context);
  }

  void onButtonCselected() {
    setState(() {
      buttonDSelected = false;
      buttonASelected = false;
      buttonBSelected = false;
      buttonCSelected = true;
      widget.controller.text = "10000";
    });
    AppUtils.hideKeyBoard(context);
  }

  void onButtonDselected() {
    setState(() {
      buttonDSelected = true;
      buttonASelected = false;
      buttonBSelected = false;
      buttonCSelected = false;
      widget.controller.text = "20000";
    });
    AppUtils.hideKeyBoard(context);
  }

  void alllButtonDeselected() {
    setState(() {
      buttonDSelected = false;
      buttonASelected = false;
      buttonBSelected = false;
      buttonCSelected = false;
    });
  }
}

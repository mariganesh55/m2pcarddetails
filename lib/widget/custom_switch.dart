import 'package:flutter/cupertino.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';

import 'custom_text.dart';

class CustomSwitch extends StatefulWidget {
  String title;
  String? subTitle;
  bool switchValue;
  Function onValueChange;

  CustomSwitch(this.title, this.subTitle, this.switchValue, this.onValueChange);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              widget.title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorResource.color1515151.withOpacity(0.8),
            ),
            if (widget.subTitle != null)
              SizedBox(
                height: 6,
              ),
            if (widget.subTitle != null)
              CustomText(
                widget.subTitle!,
                fontSize: 12,
                color: ColorResource.color1515151.withOpacity(0.4),
              ),
          ],
        ),
        Spacer(),
        CupertinoSwitch(
            value: widget.switchValue,
            onChanged: (value) {
              widget.onValueChange(value);
            })
      ],
    );
  }
}

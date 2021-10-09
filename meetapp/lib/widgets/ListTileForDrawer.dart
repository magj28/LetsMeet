import 'package:flutter/material.dart';
import 'package:meetapp/utils/color_utils.dart';

class listTileForDrawer extends StatelessWidget {
  Icon icon;
  String displayText;
  VoidCallback onTap;
  bool divider;

  listTileForDrawer(this.icon, this.displayText, this.onTap, this.divider);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: icon,
          title: Text(displayText),
          onTap: onTap,
        ),
        divider == false
            ? Container()
            : Divider(
                color: ColorUtils.greyColor,
              ),
      ],
    );
  }
}

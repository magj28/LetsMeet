import 'package:flutter/material.dart';
import 'package:meetapp/utils/color_utils.dart';

//common app bar in all screens
class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  String? title;
  Widget? leading;
  List<Widget>? action;

  CommonAppBar({Key? key, this.title, this.leading, this.action})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize;

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorUtils.color!.primaryColor,
      title: Text(widget.title!),
      leading: widget.leading,
      actions: widget.action!,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:instagram/providers/user_provider.dart';

import 'package:instagram/utils.dart/gloal_var.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenlayout;
  final Widget mobileScreenlayout;

  const ResponsiveLayout(
      {required this.mobileScreenlayout,
      required this.webScreenlayout,
      super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userp = Provider.of(context, listen: false);
    await _userp.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) {
        if (p1.maxWidth > webScreenSize) {
          return widget.webScreenlayout;
        }
        return widget.mobileScreenlayout;
      },
    );
  }
}

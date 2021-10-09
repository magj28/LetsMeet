import 'package:flutter/material.dart';

//custom circular progress indicator to be displayed while data is being fetched from the database
class CircProgressIndicator extends StatelessWidget {
  const CircProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: CircularProgressIndicator()));
  }
}

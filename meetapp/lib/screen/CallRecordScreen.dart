import 'package:flutter/material.dart';
import 'package:meetapp/logic/viewModel/callRecordViewModel.dart';
import 'package:meetapp/widgets/CallRecordWidget.dart';
import 'package:meetapp/widgets/CommonAppBar.dart';
import 'package:meetapp/widgets/CommonDrawer.dart';
import 'package:meetapp/widgets/CircProgressIndicator.dart';
import 'package:provider/provider.dart';

class CallRecordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final callRecord = Provider.of<CallRecordViewModel>(context, listen: false);
    return Scaffold(
      appBar: CommonAppBar(title: 'Call Logs', action: []),
      drawer: CommonDrawer(),
      body: Provider.of<CallRecordViewModel>(context)
              .isFetchingData //shows circular progress indicator till data loads
          ? CircProgressIndicator()
          : SingleChildScrollView(
              child: callRecord.callRecordsList!.length == 0
                  ? Center(
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Text("No Calls")),
                    )
                  : SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) {
                          return CallRecordWidget(
                              callRecord.callRecordsList![index]);
                        },
                        itemCount: callRecord.callRecordsList!.length,
                        reverse: true,
                      ),
                    ),
            ),
    );
  }
}

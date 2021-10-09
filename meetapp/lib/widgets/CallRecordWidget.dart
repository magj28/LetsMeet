import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetapp/logic/model/CallRecord.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/utils/dimensions.dart';
import 'package:provider/provider.dart';
import 'CircleAvatar.dart';

//tile displaying call record
class CallRecordWidget extends StatelessWidget {
  CallRecord callRecord;

  CallRecordWidget(this.callRecord);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    String otherUserId = callRecord.receiverID == user.user!.userID
        ? callRecord.callerID
        : callRecord.receiverID;
    String? firstName;
    String? lastName;
    String? userName;
    user.userList.forEach((individualUser) {
      if (individualUser.userID == otherUserId) {
        firstName = individualUser.firstName;
        lastName = individualUser.lastName;
        userName = individualUser.userName;
      }
    });
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  circleAvatar(firstName!, lastName!, true, spacingMedium),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(firstName! + " " + lastName!),
                        Text(
                          "@" + userName!,
                          style: TextStyle(color: ColorUtils.greyColor),
                        ),
                        Text(callRecord.dateIST +
                            ", " +
                            callRecord.startingTime),
                        callRecord.duration == null
                            ? Container()
                            : Text(callRecord.duration),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: callRecord.status == "Accepted"
                    ? callRecord.callerID == user.user!.userID
                        ? Icon(
                            Icons.call_made,
                            color: ColorUtils.acceptIcon,
                          )
                        : Icon(
                            Icons.call_received,
                            color: ColorUtils.acceptIcon,
                          )
                    : Icon(
                        Icons.call_missed,
                        color: ColorUtils.rejectIcon,
                      ),
              ),
            ],
          ),
        ),
        Divider(
          color: ColorUtils.greyColor,
        )
      ],
    );
  }
}

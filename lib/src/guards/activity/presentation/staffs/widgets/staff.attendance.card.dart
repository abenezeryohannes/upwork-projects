import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rnginfra/src/guards/activity/domain/entities/staff.attendance.entity.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/widgets/custom.shimmer.dart';
import '../../../../../core/widgets/entry.and.exit.time.dart';
import '../pages/edit.staff.attendance.page.dart';

class StaffAttendanceCard extends StatefulWidget {
  const StaffAttendanceCard({super.key, this.attendance, this.showDate = true});
  final StaffAttendanceEntity? attendance;
  final bool showDate;

  @override
  State<StaffAttendanceCard> createState() => _StaffAttendanceCardState();
}

class _StaffAttendanceCardState extends State<StaffAttendanceCard> {
  late DateTime? enter;
  late DateTime? leave;
  @override
  void initState() {
    enter = widget.attendance?.entryAt();
    leave = widget.attendance?.exitAt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.attendance != null && widget.showDate)
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
              child: CustomShimmer(
                show: widget.attendance == null,
                child: Text(
                  // (DateFormat('yyyy-MM-dd'))
                  //     .format(widget.attendance?.created ?? DateTime.now()),
                  widget.attendance?.created ?? 'unknown',
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          Material(
              elevation: 1,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 20, bottom: 20, top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CustomShimmer(
                              show: widget.attendance == null,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(
                                  widget.attendance?.user?.avatar ??
                                      'assets/icon/user.png',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomShimmer(
                                      show: widget.attendance == null,
                                      child: Text(
                                        widget.attendance?.field_user_staff ??
                                            '----------------',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                backgroundColor:
                                                    widget.attendance == null
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .onBackground
                                                        : null),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CustomShimmer(
                                      show: widget.attendance == null,
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        radius: 3,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CustomShimmer(
                                      show: widget.attendance == null,
                                      child: Text(
                                        widget.attendance?.user?.position ??
                                            'Staff Member',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                backgroundColor:
                                                    widget.attendance == null
                                                        ? Theme.of(context)
                                                            .hintColor
                                                        : null,
                                                color: Theme.of(context)
                                                    .disabledColor),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 20),
                                  child: EntryAndExitTime(
                                      entryTime: widget.attendance?.entryAt(),
                                      exitTime: widget.attendance?.exitAt()),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // InkWell(
                        //   onTap: () {},
                        //   child: CustomShimmer(
                        //     show: widget.attendance == null,
                        //     child: Container(
                        //       height: 50,
                        //       padding:
                        //           const EdgeInsets.symmetric(horizontal: 40),
                        //       decoration: BoxDecoration(
                        //           border: Border(
                        //         top: BorderSide(
                        //             color: Theme.of(context).dividerColor,
                        //             width: 1),
                        //         right: BorderSide(
                        //             color: Theme.of(context).dividerColor,
                        //             width: 1),
                        //       )),
                        //       child: Icon(
                        //         Icons.phone,
                        //         color: Theme.of(context).colorScheme.secondary,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              if (widget.attendance != null) {
                                StaffAttendanceEntity? atendance =
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return EditStaffAttendance(
                                            staffAttendanceEntity:
                                                widget.attendance!,
                                          );
                                        });
                                if (atendance != null) {
                                  setState(() {
                                    enter = atendance.entryAt();
                                    leave = atendance.exitAt();
                                  });
                                }
                              }
                            },
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Theme.of(context).dividerColor,
                                          width: 1))),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomShimmer(
                                    show: widget.attendance == null,
                                    child: Icon(
                                      Icons.calendar_today_rounded,
                                      size: 20,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  CustomShimmer(
                                    show: widget.attendance == null,
                                    child: Text(
                                      'Attendance',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              backgroundColor:
                                                  widget.attendance == null
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onBackground
                                                      : null),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ))
        ]);
  }
}

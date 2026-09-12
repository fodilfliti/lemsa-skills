import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';

@RoutePage()
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.tabs.calendar)),
      body: Center(child: Text(t.home.calendarPlaceholder)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:village_court_gems/view/AACO/aaco_info_add.dart';
import 'package:village_court_gems/view/AACO/aaco_info_edit.dart';
import 'package:village_court_gems/view/Profile/profile.dart';
import 'package:village_court_gems/view/Trainings/Trainings.dart';
import 'package:village_court_gems/view/Trainings/Trainings_info_Details.dart';
import 'package:village_court_gems/view/activity/activity_List_Details.dart';
import 'package:village_court_gems/view/activity/activity.dart';
import 'package:village_court_gems/view/field_visit_list/field_visit_try.dart';
import 'package:village_court_gems/view/activity/activity_add.dart';
import 'package:village_court_gems/view/Trainings/training_data_add&update.dart';
import 'package:village_court_gems/view/credential/login_page.dart';
import 'package:village_court_gems/view/home/homepage.dart';
import 'package:village_court_gems/view/home/splashscreen.dart';
import 'package:village_court_gems/view/AACO/aaco_Info.dart';
import 'package:village_court_gems/view/visit_report/change_location.dart';
import 'package:village_court_gems/view/visit_report/visit_report.dart';

Map<String, Widget Function(BuildContext)> pageRoute(BuildContext context) {
  return {
    '/': (context) => const SPScreen(),
    LoginPage.pageName: (context) => const LoginPage(),
    Homepage.pageName: (context) =>  Homepage(),
    TrainingDataPage.pageName: (context) => const TrainingDataPage(),
    ActivityUpdate.pageName: (context) => const ActivityUpdate(),
    VisitReport.pageName: (context) => const VisitReport(),
    CompletedFieldVisitPage.pageName: (context) => const CompletedFieldVisitPage(),
    TrainingsPage.pageName: (context) => const TrainingsPage(),
    ProfilePage.pageName: (context) => const ProfilePage(),
    ActivityShow.pageName: (context) => const ActivityShow(),
   ActivityListShow.pageName: (context) =>  ActivityListShow(),
    ChangeLocation.pageName: (context) => const ChangeLocation(),
    AACO_Info.pageName: (context) => const AACO_Info(),
    AACO_Info_Add.pageName: (context) => const AACO_Info_Add(),
    AACOInfoEditPage.pageName: (context) => AACOInfoEditPage(),
  
  };
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/services/database/offlineDistrict.dart';
import 'package:village_court_gems/services/database/offlineDivison.dart';
import 'package:village_court_gems/services/database/offlineUnion.dart';
import 'package:village_court_gems/services/database/offlineUpazilas.dart';
import 'package:village_court_gems/view/credential/login_page.dart';
import 'package:village_court_gems/view/home/homepage.dart';

class SPScreen extends StatefulWidget {
  static const pageName = 'sp';
  const SPScreen({super.key});

  @override
  State<SPScreen> createState() => _SPScreenState();
}

class _SPScreenState extends State<SPScreen> {
  // 01614863299
  Future<void> allLocation() async {
    List storeDivisonData = await Helper().getDivisionData();
    List storeDistrictData = await Helper().getDistrictData();
    List storeUpazilaData = await Helper().getUpazilaData();
    List storeUnionData = await Helper().getUnionData(); 

    if (storeDivisonData.isEmpty) {
      Map division = await Repositores().divisionApi();
      if (division['status'] == 200) {
        print("divison");
        Helper().DivisionDataInsert(division["data"]);
      }
    }
    if (storeDistrictData.isEmpty) {
      print("district");
      Map district = await Repositores().districtOfflineApi();
      if (district['status'] == 200) {
        Helper().DistrictDataInsert(district['data']);
      }
      //Helper().DistrictDataInsert(OfflineDistrict().districtData);
    }
    if (storeUpazilaData.isEmpty) {
      print("upazila");
      Map upazila = await Repositores().upazilaOflineApi();
      if (upazila['status'] == 200) {
        Helper().UpazilaDataInsert(upazila['data']);
      }
      //  Helper().UpazilaDataInsert(OfflineUpazila().UpazilaData);
    }
    if (storeUnionData.isEmpty) {
      print("union");
      Map union = await Repositores().unionOflineApi();
      if (union['status'] == 200) {
        Helper().UnionDataInsert(union['data']);
      }
      // Helper().UnionDataInsert(OfflineUnion().unionData);
    }
  }

  @override
  void initState() {
    allLocation();
    Future.delayed(Duration(seconds: 1), () async {
      dynamic token = await Helper().getUserToken();

      if (token == null) {
        print("loginnnnnnnnnnnnnnn");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
        );
      } else {
        await Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Homepage()), (Route<dynamic> route) => false);
      }
      print(token);
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
          child: Column(
            children: [
              SizedBox(
                height: 120.0.h,
              ),
              // Container(
              //   height: 30,
              //   color: Colors.black,
              //   child: Switch(
              //     activeColor: Colors.amber,
              //     value: context.locale.toString() == 'en' ? true : false,
              //     onChanged: (bool value) {
              //       value ? context.setLocale(const Locale('en')) : context.setLocale(const Locale('bn'));
              //       //Refresh.refressLocalization();
              //     },
              //   ),
              // ),
              // Text(
              //   context.locale.toString() == 'en' ? 'English' : 'বাংলা',
              //   style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 105, 29, 29)),
              // ),
              SizedBox(height: 50, child: Image.asset("assets/icons/idsdp_logo.png")),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 35, right: 20),
                child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "GPS Based E-Monitoring System (GEMS)\n                              for \nActivating Village Courts in Bangladesh\n                  (Phase III) Project",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              Image.asset(
                'assets/icons/Rectangle 1.png',
                //  width: 30,
                height: 402,
              ),

              SizedBox(
                height: 50.0.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Design & Developed By:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'assets/icons/Dream71_logo 1 1.png',
                    height: 20,
                    //  width: 30,
                  ),
                ],
              ),

              SizedBox(
                height: 30.0.h,
              ),

              SizedBox(
                height: 30.0.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

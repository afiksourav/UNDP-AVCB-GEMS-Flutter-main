import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompletedFieldVisitPage extends StatefulWidget {
  static const pageName = 'field_finding';
  const CompletedFieldVisitPage({super.key});

  @override
  State<CompletedFieldVisitPage> createState() => _CompletedFieldVisitPageState();
}

class _CompletedFieldVisitPageState extends State<CompletedFieldVisitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(
          "Checklist for Field Findings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              trailing: Icon(Icons.add), // Icon for the leading position
              title: Text(
                '1. Discussion with Up Functionaries(UP Chair/\n    UPMember/ACCO/UPS)',
                style: TextStyle(fontSize: 12),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300, // Set to null for an unlimited number of lines
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Findings',
                        ),
                      )),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300, // Set to null for an unlimited number of lines
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Support Provided',
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            ExpansionTile(
              trailing: Icon(Icons.add), // Icon for the leading position
              title: Text(
                "2. Review VC's Documentation",
                style: TextStyle(fontSize: 12),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300, // Set to null for an unlimited number of lines
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Findings',
                        ),
                      )),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300, // Set to null for an unlimited number of lines
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Support Provided',
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            ExpansionTile(
              trailing: Icon(Icons.add), // Icon for the leading position
              title: Text(
                "3. Observe hearing session",
                style: TextStyle(fontSize: 12),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300, // Set to null for an unlimited number of lines
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Findings',
                        ),
                      )),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300, // Set to null for an unlimited number of lines
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Support Provided',
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            ExpansionTile(
              trailing: Icon(Icons.add), // Icon for the leading position
              title: Text(
                "4. Arrend Different metings(at UP Level,Upazilla level\n    and District level etc)",
                style: TextStyle(fontSize: 12),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300, // Set to null for an unlimited number of lines
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Findings',
                        ),
                      )),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300, // Set to null for an unlimited number of lines
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Support Provided',
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            ExpansionTile(
              trailing: Icon(Icons.add), // Icon for the leading position
              title: Text(
                "5. Provides supports in organizing Workshop/seminar",
                style: TextStyle(fontSize: 12),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300, // Set to null for an unlimited number of lines
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Findings',
                        ),
                      )),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300, // Set to null for an unlimited number of lines
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Support Provided',
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10.0.h,
            ),
            ExpansionTile(
              trailing: const Icon(Icons.add),
              title: const Text(
                "6. Provides suports in organizing tra",
                style: TextStyle(fontSize: 12),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Findings',
                        ),
                      )),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                  child: SizedBox(
                      height: 100.0.h,
                      width: double.infinity,
                      child: const TextField(
                        maxLines: 300, // Set to null for an unlimited number of lines
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: 'Support Provided',
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 30.0.h,
            ),
            Center(
              child: SizedBox(
                width: 330.w,
                height: 50.h,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0.r),
                      ),
                      backgroundColor: Color.fromARGB(255, 22, 131, 26),
                    ),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Submit",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(autoStart: true, onForeground: onStart, onBackground: onIosBackground),
      androidConfiguration: AndroidConfiguration(onStart: onStart, isForegroundMode: true, autoStart: true));
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // AppLogger.instance.logger.d("On start service");
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on("setAsForeground").listen((event) {
      service.setAsForegroundService();
    });
    service.on("setAsBackground").listen((event) {
      service.setAsBackgroundService();
    });
    service.on("stopService").listen((event) {
      service.stopSelf();
    });

/*    print("g_binHolderName:$g_binHolderName");
    print("g_binHolderID:$g_binHolderID");
    print("g_accessToken:$g_accessToken");
    print("g_deviceId:$g_deviceId");
    print("g_password:$g_password");
    print("g_nbrDeviceID:$g_nbrDeviceID");
    print("g_DeviceRole:$g_DeviceRole");*/

    Timer.periodic(const Duration(minutes: 1), (timer) async {
      // AppLogger.instance.logger.d("Inside Time");
      // if (g_SerinalNumber != "") {
      //   await AllService().pulseCheck();
      // }
      // AppLogger.instance.logger.d("After pulse check");

      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(title: "Foreground", content: "sub my channel");
      }

      print("background service runing");
      print("background service runing");

      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet) {
        //AllService().thirdPartyInvoiceSent();
        // g_DeviceRole == "SDC" ? AllService().thirdPartyInvoiceSent() : AllService().invoiceStatusSync();
      }
      service.invoke("update");
    });
  }

  // AppLogger.instance.logger.d("After Timer");
}

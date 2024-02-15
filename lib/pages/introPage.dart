import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/pages/mainMenu.dart';
import 'package:permission_handler/permission_handler.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Music Player"),
          ),
          Center(
            child: TextButton(
                onPressed: () async {
                  var status = await Permission.storage.request();

                  if (status.isDenied) {Get.snackbar(
                        icon: Icon(Icons.cancel_outlined),
                        colorText: Colors.red,
                        isDismissible: true,
                        "PERMISSION DENIED",
                        "Permission was denied by user."
                            "Please Open your App settings-permissions page and give access to files and medias",
                        duration: Duration(seconds: 10));
                  } else if (status.isGranted) {
                    Get.snackbar(
                        icon: Icon(Icons.verified_user_outlined),
                        colorText: Colors.green,
                        isDismissible: true,
                        "PERMISSION GRANTED",
                        "Permission was successfully granted");
                  } else if (status.isPermanentlyDenied) {Get.snackbar(
                        icon: Icon(Icons.block),
                        colorText: Colors.red,
                        "PERMISSION DENIED",
                        "Permission is restricted by user."
                          "Please Open your App settings-permissions page and give access to files and medias",
                           onTap: (snack) {
                             openAppSettings();
                           },isDismissible: true,
                        duration: Duration(seconds: 5));

                      
                 
                    
                  }
                },
                child: Text("GET STORAGE PERMISSIONS")),
          ),
          Center(
            child: InkWell(
              
              child: Text("Lets Get Started!"),
              onTap: () {
                Get.to(MainMenu());
              },
            )
          ),
        ],
      ),
    );
  }
}

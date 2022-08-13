// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kuis_1/app/data/Controller/auth_controller.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Container(
        margin: context.isPhone
            ? EdgeInsets.all(Get.width * 0.1)
            : EdgeInsets.all(Get.height * 0.1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: Row(
          children: [
            !context.isPhone
                ? Expanded(
                    // biru
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                        color: Colors.blue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Selamat Datang",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 55),
                            ),
                            Text(
                              "Silahkan daftar untuk memulai",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            Text(
                              "perjalananmu bersama kita",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Expanded(
              // putih
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      context.isPhone
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                  Text(
                                    "Selamat Datang",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 40),
                                  ),
                                  Text(
                                    "Silahkan daftar untuk memulai ",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  Text(
                                    "perjalananmu bersama kita",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  )
                                ])
                          : const SizedBox(),
                      Image.asset(
                        'assets/images/login.png',
                        height: Get.height * 0.5,
                      ),
                      FloatingActionButton.extended(
                        onPressed: () => authC.signInWithGoogle(),
                        label: const Text('Sign With Google'),
                        icon: const Icon(
                          Ionicons.logo_google,
                          color: Colors.white,
                        ),
                      )
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kuis_1/app/data/Controller/auth_controller.dart';
import 'package:kuis_1/app/utils/style/AppColours.dart';
import 'package:kuis_1/app/utils/widget/header.dart';

import 'package:kuis_1/app/utils/widget/profile.dart';
import 'package:kuis_1/app/utils/widget/sidebar.dart';
import 'package:kuis_1/app/utils/widget/temenmungkin.dart';

import '../controllers/profile_controller.dart';

// ignore: use_key_in_widget_constructors
class ProfileView extends GetView<ProfileController> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: const SizedBox(width: 150, child: Sidebar()),
      backgroundColor: AppColours.primaryBg,
      body: SafeArea(
        child: Row(
          children: [
            !context.isPhone
                ? const Expanded(
                    flex: 2,
                    child: Sidebar(),
                  )
                : const SizedBox(),
            Expanded(
              flex: 15,
              child: Column(
                children: [
                  !context.isPhone
                      ? const Header()
                      : Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _drawerKey.currentState!.openDrawer();
                                },
                                icon: const Icon(
                                  Ionicons.menu,
                                  color: AppColours.primaryText,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Task Management",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 66, 60, 60)),
                                  ),
                                  Text(
                                    "Manage your task easier with your friend",
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Get.defaultDialog(
                                      title: "Keluar",
                                      content: const Text("Yakin mau keluar?"),
                                      cancel: ElevatedButton(
                                          onPressed: () => Get.back(),
                                          child: const Text("Gak Jadi")),
                                      confirm: ElevatedButton(
                                        onPressed: () => authC.logout(),
                                        child: const Text("Yakin"),
                                      ));
                                },
                                child: Row(
                                  children: const [
                                    Text(
                                      "Sign Out",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Ionicons.log_out_outline,
                                        color: Colors.grey, size: 30)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  // content
                  Expanded(
                    child: Container(
                      padding: !context.isPhone
                          ? const EdgeInsets.all(50)
                          : const EdgeInsets.all(20),
                      margin: !context.isPhone
                          ? const EdgeInsets.all(10)
                          : const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: !context.isPhone
                              ? BorderRadius.circular(50)
                              : BorderRadius.circular(30)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileWidget(),
                          const Text(
                            "Teman yang mungkin kamu tau",
                            style: TextStyle(
                                color: AppColours.primaryText, fontSize: 30),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 200,
                            child: TemenMungkin(),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

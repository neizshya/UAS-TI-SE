// import 'dart:html';

// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kuis_1/app/utils/style/AppColours.dart';
import 'package:kuis_1/app/utils/widget/header.dart';
import 'package:kuis_1/app/utils/widget/myfriend.dart';

import 'package:kuis_1/app/utils/widget/sidebar.dart';
import 'package:kuis_1/app/utils/widget/temenmungkin.dart';
import 'package:kuis_1/app/utils/widget/upcomingtask.dart';
import '../../../data/Controller/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final authCon = Get.find<AuthController>();

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
                              const Icon(
                                Ionicons.notifications,
                                color: Colors.grey,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  radius: 25,
                                  foregroundImage: NetworkImage(
                                      authCon.auth.currentUser!.photoURL!),
                                ),
                              )
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // my task
                          SizedBox(
                            height: Get.height * 0.3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Teman yang mungkin kamu tau",
                                  style: TextStyle(
                                      color: AppColours.primaryText,
                                      fontSize: 30),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TemenMungkin(),
                              ],
                            ),
                          ),

                          !context.isPhone
                              ? Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      upcoming(),
                                      MyFriend(),
                                    ],
                                  ),
                                )
                              : const Text(
                                  "Tugas",
                                  style: TextStyle(
                                      color: AppColours.primaryText,
                                      fontSize: 30),
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          upcoming(),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kuis_1/app/routes/app_pages.dart';
import 'package:kuis_1/app/utils/style/AppColours.dart';

import '../../data/Controller/auth_controller.dart';

class MyFriend extends StatelessWidget {
  final authCon = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "My Friends",
                    style: TextStyle(
                      color: AppColours.primaryText,
                      fontSize: 30,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.FRIENDS),
                    child: const Text(
                      "more",
                      style: TextStyle(
                          color: AppColours.primaryText, fontSize: 20),
                    ),
                  ),
                  const Icon(
                    Ionicons.chevron_forward,
                    color: AppColours.primaryText,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 400,
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: authCon.streamFriends(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var myFriends = (snapshot.data?.data()
                        as Map<String, dynamic>)['friendsEmail'] as List;

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: myFriends.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: !context.isPhone ? 3 : 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20),
                      itemBuilder: (context, index) {
                        return StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                            stream: authCon.streamUsers(myFriends[index]),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              var dataUser = snapshot2.data!.data();

                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                      image: NetworkImage(dataUser!['photos']),
                                      height: Get.width * 0.35,
                                      width: Get.width * 0.4,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    dataUser['name'],
                                    style: TextStyle(
                                        color: AppColours.primaryText),
                                  )
                                ],
                              );
                            });
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kuis_1/app/utils/style/AppColours.dart';
import 'package:get/get.dart';

import '../../data/Controller/auth_controller.dart';

class ProfileWidget extends StatelessWidget {
  final authC = Get.find<AuthController>();

  ProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: !context.isPhone
          ? Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 150,
                      foregroundImage:
                          NetworkImage(authC.auth.currentUser!.photoURL!),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authC.auth.currentUser!.displayName!,
                        style: const TextStyle(
                            color: AppColours.primaryText, fontSize: 40),
                      ),
                      Text(
                        authC.auth.currentUser!.email!,
                        style: const TextStyle(
                            color: AppColours.primaryText, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  ClipRRect(
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 150,
                      foregroundImage:
                          NetworkImage(authC.auth.currentUser!.photoURL!),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    authC.auth.currentUser!.displayName!,
                    style: const TextStyle(
                        color: AppColours.primaryText, fontSize: 30),
                  ),
                  Text(
                    authC.auth.currentUser!.email!,
                    style: const TextStyle(
                        color: AppColours.primaryText, fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kuis_1/app/data/Controller/auth_controller.dart';
import 'package:kuis_1/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "task manager",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController(), permanent: true);
  runApp(StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Application",
        initialRoute: snapshot.data != null ? Routes.HOME : Routes.LOGIN,
        getPages: AppPages.routes,
      );
    },
  ));
}

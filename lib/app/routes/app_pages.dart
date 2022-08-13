// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import '../modules/friends/bindings/friends_binding.dart';
import '../modules/friends/views/friends_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/task/bindings/task_binding.dart';
import '../modules/task/views/task_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => HomeView(),
        binding: HomeBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 200)),
    GetPage(
        name: _Paths.LOGIN,
        page: () => LoginView(),
        binding: LoginBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 200)),
    GetPage(
        name: _Paths.TASK,
        page: () => TaskView(),
        binding: TaskBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 200)),
    GetPage(
        name: _Paths.PROFILE,
        page: () => ProfileView(),
        binding: ProfileBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 200)),
    GetPage(
        name: _Paths.FRIENDS,
        page: () => FriendsView(),
        binding: FriendsBinding(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 200)),
  ];
}

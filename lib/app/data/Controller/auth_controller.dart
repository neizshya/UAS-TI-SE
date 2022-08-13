// ignore_for_file: avoid_print, unnecessary_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kuis_1/app/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? _userCredential;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController searchFriendController;
  late TextEditingController titleController,
      descriptionController,
      dueController;
  @override
  void onInit() {
    super.onInit();
    searchFriendController = TextEditingController();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    dueController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    searchFriendController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dueController.dispose();
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await auth
        .signInWithCredential(credential)
        .then((value) => _userCredential = value);

    // firebase
    CollectionReference users = firestore.collection('users');

    final cekUser = await users.doc(googleUser!.email).get();
    if (!cekUser.exists) {
      users.doc(googleUser.email).set({
        'uid': _userCredential!.user!.uid,
        'name': googleUser.displayName,
        'email': googleUser.email,
        'photos': googleUser.photoUrl,
        'idTask': [],
        'createdAt': _userCredential!.user!.metadata.creationTime.toString(),
        'lastLoginAt':
            _userCredential!.user!.metadata.lastSignInTime.toString(),
        // 'list cari' :googleUser?.email
      }).then((value) async {
        String temp = '';

        try {
          for (var i = 0; i < googleUser.displayName!.length; i++) {
            temp = temp + googleUser.displayName![i];
            await users.doc(googleUser.email).set({
              'list_cari': FieldValue.arrayUnion([temp.toUpperCase()]),
            }, SetOptions(merge: true));
          }
        } catch (e) {
          print(e);
        }
      });
    } else {
      users.doc(googleUser.email).update({
        'lastLoginAt':
            _userCredential!.user!.metadata.lastSignInTime.toString(),
      });
    }
    Get.offAllNamed(Routes.HOME);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    Get.offAllNamed(Routes.LOGIN);
  }

  var kataCari = [].obs;
  var hasilPencarian = [].obs;
  void searchFriend(String keyword) async {
    CollectionReference users = firestore.collection('users');
    if (keyword.isNotEmpty) {
      final hasilQuery = await users
          .where('list_cari', arrayContains: keyword.toUpperCase())
          .get();
      if (hasilQuery.docs.isNotEmpty) {
        for (var i = 0; i < hasilQuery.docs.length; i++) {
          kataCari.add(hasilQuery.docs[i].data() as Map<String, dynamic>);
        }
      }
      if (kataCari.isNotEmpty) {
        hasilPencarian.value = [];
        kataCari.forEach((element) {
          hasilPencarian.add(element);
        });
        kataCari.clear();
      }
    } else {
      kataCari.value = [];
      hasilPencarian.value = [];
    }
    kataCari.refresh();
    hasilPencarian.refresh();
  }

  void addFriends(String friendsEmail) async {
    CollectionReference friends = firestore.collection('friends');

    final checkFriends = await friends.doc(auth.currentUser!.email).get();

    // cek data
    if (checkFriends.data() == null) {
      await friends.doc(auth.currentUser!.email).set({
        'CurrentUserEmail': auth.currentUser!.email,
        'friendsEmail': [friendsEmail]
      }).whenComplete(() => Get.snackbar("Friends", "test"));
    } else {
      await friends.doc(auth.currentUser!.email).set(
          {
            'friendsEmail': FieldValue.arrayUnion([friendsEmail]),
          },
          SetOptions(
            merge: true,
          )).whenComplete(() => Get.snackbar("Friends", "Friends added successfully"));
    }
    kataCari.clear();
    hasilPencarian.clear();
    searchFriendController.clear();
    Get.back();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamFriends() {
    return firestore
        .collection('friends')
        .doc(auth.currentUser!.email)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUsers(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPeople() async {
    CollectionReference friends = firestore.collection('friends');
    // fetch data friends

    final cekFriends = await friends.doc(auth.currentUser!.email).get();
    var listFriends =
        (cekFriends.data() as Map<String, dynamic>)['friendsEmail'] as List;
    QuerySnapshot<Map<String, dynamic>> hasil = await firestore
        .collection('users')
        .where('email', whereNotIn: listFriends)
        .get();

    return hasil;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTask(String taskId) {
    return firestore.collection('task').doc(taskId).snapshots();
  }

  void saveUpdateTask(
      {String? title,
      String? description,
      String? dueDate,
      String? docId,
      String? type}) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    CollectionReference taskColl = firestore.collection('task');
    CollectionReference usersColl = firestore.collection('users');
    var taskId = DateTime.now().toIso8601String();
    if (type == 'Add') {
      await taskColl.doc(taskId).set({
        'title': title,
        'description': description,
        'due_Date': dueDate,
        'status': '0',
        'total_task': '0',
        'total_finished': '0',
        'task_detail': [],
        'assign': [auth.currentUser!.email],
        'created_by': auth.currentUser!.email
      }).whenComplete(() async {
        await usersColl.doc(auth.currentUser!.email).set({
          'idTask': FieldValue.arrayUnion([taskId]),
        }, SetOptions(merge: true));
        Get.back();
        Get.snackbar('Tugas', "Berhasil $type tugas");
      }).catchError((err) {
        Get.snackbar('Tugas', "Error $type");
      });
    } else {
      await taskColl.doc(docId).update({
        'title': title,
        'description': description,
        'due_Date': dueDate,
      }).whenComplete(() async {
        Get.back();
        Get.snackbar('Tugas', "Berhasil $type");
      }).catchError((err) {
        Get.snackbar('Tugas', "Error $type");
      });
    }
  }

  void deleteTask(String taskId) async {
    CollectionReference taskColl = firestore.collection('task');
    CollectionReference usersColl = firestore.collection('users');
    print(taskId);
    await taskColl.doc(taskId).delete().then((value) async {
      await usersColl.doc(auth.currentUser!.email).set({
        'idTask': FieldValue.arrayRemove([taskId])
      }, SetOptions(merge: true));
    }).whenComplete(() {
      Get.back();
      Get.snackbar('Tugas', "Berhasil Dihapus");
    });

    // whenComplete(() async {
    //   await usersColl.doc(auth.currentUser!.email).set({
    //     'idTask': FieldValue.arrayRemove([taskId])
    //   }, SetOptions(merge: true));
    //   Get.back();
    //   Get.snackbar('Tugas', "Berhasil dihapus");
    // });
  }
}

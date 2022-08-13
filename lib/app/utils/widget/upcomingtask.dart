import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kuis_1/app/utils/style/AppColours.dart';

import '../../data/Controller/auth_controller.dart';
import 'addedittask.dart';

// ignore: camel_case_types
class upcoming extends StatelessWidget {
  final authCon = Get.find<AuthController>();

  upcoming({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          //strem user get task
          stream: authCon.streamUsers(authCon.auth.currentUser!.email!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            //task Id get
            var taskId = (snapshot.data!.data()
                as Map<String, dynamic>)['idTask'] as List;

            return ListView.builder(
              itemCount: taskId.length,
              clipBehavior: Clip.antiAlias,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: authCon.streamTask(taskId[index]),
                    builder: (context, snapshot2) {
                      if (snapshot2.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      //data taskk
                      var dataTask = snapshot2.data!.data();
                      //data user ptot
                      var dataUserList = (snapshot2.data!.data()
                          as Map<String, dynamic>)['assign'] as List;

                      return GestureDetector(
                        //edit
                        onLongPress: () {
                          Get.defaultDialog(
                              title: dataTask!['title'],
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //update

                                  TextButton.icon(
                                    onPressed: () {
                                      Get.back();
                                      authCon.titleController.text =
                                          dataTask['title'];
                                      authCon.descriptionController.text =
                                          dataTask['description'];
                                      authCon.dueController.text =
                                          dataTask['due_date'];
                                      addEditTask(
                                          context: context,
                                          type: 'Update',
                                          docId: taskId[index]);
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text('Update'),
                                  ),
                                  //delete ngarah ke authController
                                  TextButton.icon(
                                    onPressed: () {
                                      authCon.deleteTask(taskId[index]);
                                    },
                                    icon: const Icon(Icons.delete),
                                    label: const Text('Delete'),
                                  )
                                ],
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColours.cardBg,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    child: Expanded(
                                      child: ListView.builder(
                                        itemCount: dataUserList.length,
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index2) {
                                          return StreamBuilder<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>(
                                              stream: authCon.streamUsers(
                                                  dataUserList[index2]),
                                              builder: (context, snapshot3) {
                                                if (snapshot3.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }

                                                //data user phoyo
                                                var dataUserImage =
                                                    snapshot3.data!.data();
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.amber,
                                                    radius: 20,
                                                    foregroundImage:
                                                        NetworkImage(
                                                            dataUserImage![
                                                                'photos']),
                                                  ),
                                                );
                                              });
                                        },
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 25,
                                    width: 80,
                                    color: AppColours.primaryBg,
                                    child: Center(
                                        child: Text(
                                      dataTask!['status'],
                                      style: const TextStyle(
                                        color: AppColours.primaryText,
                                      ),
                                    )),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 20,
                                width: 80,
                                color: AppColours.primaryBg,
                                child: Center(
                                    child: Text(
                                  '${dataTask['total_finished']} / ${dataTask['total_task']} Task',
                                  style: const TextStyle(
                                    color: AppColours.primaryText,
                                  ),
                                )),
                              ),
                              Text(
                                dataTask['title'],
                                style: const TextStyle(
                                    color: AppColours.primaryText,
                                    fontSize: 20),
                              ),
                              Text(
                                dataTask['description'],
                                style: const TextStyle(
                                    color: AppColours.primaryText,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            );
          }),
    );
  }
}

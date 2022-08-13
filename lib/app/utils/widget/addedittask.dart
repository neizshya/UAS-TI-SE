import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/Controller/auth_controller.dart';
import '../style/AppColours.dart';

addEditTask({BuildContext? context, String? type, String? docId}) {
  final authCon = Get.find<AuthController>();

  Get.bottomSheet(SingleChildScrollView(
    child: Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      margin: context!.isPhone
          ? EdgeInsets.zero
          : const EdgeInsets.only(left: 150, right: 150),
      // height: Get.height,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white),
      child: Form(
        key: authCon.formKey,
        child: Column(
          children: [
            Text(
              '$type Task',
              style: const TextStyle(
                  color: AppColours.primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Judul',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              controller: authCon.titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: InputDecoration(
                  hintText: 'Deskripsi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              controller: authCon.descriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DateTimePicker(
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              dateLabelText: 'Deadline',
              dateHintText: 'Deadline',
              decoration: InputDecoration(
                  hintText: 'Deadline',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              controller: authCon.dueController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(width: Get.width, height: 40),
              child: ElevatedButton(
                onPressed: () {
                  authCon.saveUpdateTask(
                    title: authCon.titleController.text,
                    description: authCon.descriptionController.text,
                    dueDate: authCon.dueController.text,
                    docId: docId,
                    type: type,
                  );
                },
                child: Text(type!),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ),
  ));
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/models/class_model.dart';
import 'package:student_tracker/app/models/student_model.dart';
import 'package:student_tracker/app/modules/home/controllers/children_profile_controller.dart';

import '../../controllers/students_controller.dart';

class ChildrenPage extends GetView<ChildrenProfileController> {
  ChildrenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Children'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.fetchChildrenList();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Children',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Obx(() => controller.isLoading.value
                ? Center(
                    child:
                        SpinKitDualRing(color: Get.theme.colorScheme.primary),
                  )
                : controller.childrenList.isEmpty
                    ? const SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.person,
                              size: 56,
                            ),
                            SizedBox(height: 15),
                            Text("You have registered no children for now")
                          ],
                        ),
                      )
                    : Expanded(
                        child: GetBuilder<ChildrenProfileController>(
                          id: "students_list",
                          builder: (controller) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: controller.childrenList.length,
                              itemBuilder: (context, studentIndex) {
                                final student =
                                    controller.childrenList[studentIndex];
                                return StudentCard(
                                    student: student,
                                    isParent: true,
                                    onRemove: (s) {
                                      controller.removeChild(s);
                                    },
                                    onEdit: (s) {});
                              },
                            );
                          },
                        ),
                      )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Child",
        child: const Icon(Icons.add),
        onPressed: () {
          controller.registerStudent();
        },
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  final StudentModel student;
  final void Function(StudentModel) onRemove;
  final void Function(StudentModel) onEdit;

  final bool? isParent;

  const StudentCard(
      {super.key,
      required this.student,
      required this.onRemove,
      this.isParent = false,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  student.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isParent == false)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => onEdit(student),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => onRemove(student),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Age: ${student.age}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Code: ${student.code}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/models/class_model.dart';
import 'package:student_tracker/app/models/student_model.dart';
import 'package:student_tracker/app/models/subject_model.dart';
import 'package:student_tracker/app/modules/home/controllers/subjects_controller.dart';

import '../../controllers/students_controller.dart';

class SubjectsPage extends GetView<SubjectsController> {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.fetchSubjectsList();
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
              'Subjects',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Obx(() => controller.currentClass.value == null
                ? const SizedBox.shrink()
                : DropdownButton<String>(
                    value: controller.currentClass.value!.id,
                    onChanged: (String? id) {
                      if (id == null) return;

                      controller.selectClass(id);
                    },
                    items: controller.classesController.classes
                        .map<DropdownMenuItem<String>>((ClassModel classModel) {
                      return DropdownMenuItem<String>(
                        value: classModel.id,
                        child: Text(classModel.name),
                      );
                    }).toList(),
                  )),
            const SizedBox(height: 20),
            Obx(() => controller.currentClass.value != null &&
                    controller.getCurrentSubjects != null
                ? Text('${controller.currentClass.value!.name} Subjects:')
                : const SizedBox.shrink()),
            const SizedBox(height: 24),
            Obx(() => controller.currentClass.value == null ||
                    controller.classesController.classes.isEmpty
                ? const SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.school,
                          size: 56,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "To be able to create a subject, start by adding a class to your school on the classes tab",
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )
                : controller.getCurrentSubjects == null
                    ? const SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.book,
                              size: 56,
                            ),
                            SizedBox(height: 15),
                            Text("There are no subjects for now")
                          ],
                        ),
                      )
                    : controller.isLoading.value
                        ? Center(
                            child: SpinKitDualRing(
                                color: Get.theme.colorScheme.primary),
                          )
                        : Expanded(
                            child: GetBuilder<SubjectsController>(
                              id: "subjects_list",
                              builder: (controller) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount:
                                      controller.getCurrentSubjects!.length,
                                  itemBuilder: (context, subjectIndexx) {
                                    final subject = controller
                                        .getCurrentSubjects![subjectIndexx];
                                    return SubjectCard(
                                      subject: subject,
                                      onRemove: (s) =>
                                          controller.deleteSubject(subject),
                                      onEdit: (s) =>
                                          controller.editSubject(subject),
                                    );
                                  },
                                );
                              },
                            ),
                          )),
          ],
        ),
      ),
      floatingActionButton:
          Obx(() => controller.classesController.classes.isEmpty
              ? const SizedBox.shrink()
              : FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          width: Get.width * 0.4,
                          child: AlertDialog(
                            title: const Text('Add a Subject'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: controller.nameController,
                                  decoration:
                                      const InputDecoration(labelText: 'Name'),
                                ),
                              ],
                            ),
                            actions: [
                              SizedBox(
                                width: Get.width < 600 ? double.maxFinite : 250,
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.addSubject();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Add'),
                                ),
                              ),
                              if (Get.width > 600)
                                SizedBox(
                                  width:
                                      Get.width < 600 ? double.maxFinite : 250,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.nameController.clear();

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                )),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final void Function(SubjectModel) onRemove;
  final void Function(SubjectModel) onEdit;

  const SubjectCard(
      {super.key,
      required this.subject,
      required this.onRemove,
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
                  subject.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => onEdit(subject),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => onRemove(subject),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

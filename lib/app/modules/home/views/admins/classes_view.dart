import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/modules/home/controllers/classes_controller.dart';

import '../../../../widgets/class_card.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final classesController = Get.put<ClassesController>(ClassesController());

  void editClass(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: Get.width * 0.4,
          child: AlertDialog(
            title: const Text('Edit Class'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: classesController.nameController,
                  decoration: const InputDecoration(labelText: 'Class Name'),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    classesController.editClass(id);
                    Get.back();
                  },
                  child: const Text('Save'),
                ),
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    classesController.nameController.clear();
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              classesController.fetchClassesList();
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
              'Classes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              return classesController.isLoading.value
                  ? Center(
                      child: SpinKitDualRing(
                        color: Get.theme.colorScheme.primary,
                        lineWidth: 4,
                      ),
                    )
                  : classesController.classes.isEmpty
                      ? Center(
                          child: Column(children: [
                            const Icon(
                              FontAwesomeIcons.school,
                              size: 56,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "There are no classes for the moment. Add one  by clicking the + button",
                              style: Get.textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            )
                          ]),
                        )
                      : Expanded(
                          child: GetBuilder<ClassesController>(
                            id: "classes_list",
                            builder: (controller) {
                              return ListView.builder(
                                itemCount: classesController.classes.length,
                                itemBuilder: (context, index) {
                                  return ClassCard(
                                    classModel:
                                        classesController.classes[index],
                                    onDelete: (cls) =>
                                        classesController.deleteClass(cls),
                                    onEdit: (classModel) {
                                      classesController.nameController.text =
                                          classModel.name;
                                      editClass(classModel.id);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                width: Get.width * 0.4,
                child: AlertDialog(
                  title: const Text('Add Class'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: classesController.nameController,
                        decoration:
                            const InputDecoration(labelText: 'Class Name'),
                      ),
                    ],
                  ),
                  actions: [
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () async {
                          classesController.addClass();
                          Get.back();
                        },
                        child: const Text('Add'),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          classesController.nameController.clear();

                          Get.back();
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
      ),
    );
  }
}

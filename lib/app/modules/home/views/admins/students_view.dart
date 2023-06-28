import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/models/class_model.dart';
import 'package:student_tracker/app/models/student_model.dart';
import 'package:student_tracker/app/modules/home/controllers/classes_controller.dart';

import '../../controllers/students_controller.dart';

class StudentsPage extends StatelessWidget {
  final studentsController = Get.put(StudentsController());

  StudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              studentsController.fetchClassStudentsList();
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
              'Students',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Obx(() => studentsController.currentClass.value == null
                ? const SizedBox()
                : DropdownButton<String>(
                    value: studentsController.currentClass.value!.id,
                    onChanged: (String? id) {
                      if (id == null) return;

                      studentsController.selectClass(id);
                    },
                    items: studentsController.classesController.classes
                        .map<DropdownMenuItem<String>>((ClassModel classModel) {
                      return DropdownMenuItem<String>(
                        value: classModel.id,
                        child: Text(classModel.name),
                      );
                    }).toList(),
                  )),
            const SizedBox(height: 20),
            Obx(() => studentsController.currentClass.value != null
                ? Text(
                    'Students in ${studentsController.currentClass.value!.name}:')
                : const SizedBox.shrink()),
            const SizedBox(height: 24),
            Obx(() => studentsController.currentClass.value == null ||
                    ClassesController.to.classes.isEmpty
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
                          "To be able to add a student, start by adding a class to your school on the classes tab",
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )
                : studentsController.getCurrentStudents == null
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
                            Text(
                                "There are no students for now. click on the \"+\" button below to add a student")
                          ],
                        ),
                      )
                    : Expanded(
                        child: GetBuilder<StudentsController>(
                          id: "students_list",
                          builder: (controller) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount:
                                  studentsController.getCurrentStudents!.length,
                              itemBuilder: (context, studentIndex) {
                                final student = studentsController
                                    .getCurrentStudents![studentIndex];
                                return StudentCard(
                                  student: student,
                                  onRemove: (s) =>
                                      studentsController.deleteStudent(student),
                                  onEdit: (s) =>
                                      studentsController.editStudent(student),
                                );
                              },
                            );
                          },
                        ),
                      )),
          ],
        ),
      ),
      floatingActionButton: Obx(() => studentsController.currentClass.value ==
                  null ||
              studentsController.classesController.classes.isEmpty
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
                        title: const Text('Add a Student'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: studentsController.fullNameController,
                              decoration:
                                  const InputDecoration(labelText: 'Name'),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: studentsController.ageController,
                              decoration:
                                  const InputDecoration(labelText: 'Age'),
                            ),
                          ],
                        ),
                        actions: [
                          SizedBox(
                            width: Get.width < 600 ? double.maxFinite : 250,
                            child: ElevatedButton(
                              onPressed: () {
                                studentsController.addStudent();
                                Navigator.pop(context);
                              },
                              child: const Text('Add'),
                            ),
                          ),
                          if (Get.width > 600)
                            SizedBox(
                              width: Get.width < 600 ? double.maxFinite : 250,
                              child: ElevatedButton(
                                onPressed: () {
                                  studentsController.fullNameController.clear();
                                  studentsController.ageController.clear();
                                  studentsController.ageController.clear();
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

class StudentCard extends StatelessWidget {
  final StudentModel student;
  final void Function(StudentModel) onRemove;
  final void Function(StudentModel) onEdit;

  const StudentCard(
      {super.key,
      required this.student,
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
                  student.fullName,
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

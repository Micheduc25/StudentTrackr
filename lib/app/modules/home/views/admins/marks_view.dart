import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/settings_controller.dart';
import 'package:student_tracker/app/models/marks_model.dart';
import 'package:student_tracker/app/modules/home/controllers/marks_controller.dart';

class MarksView extends GetView<MarksController> {
  const MarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marks Management"),
        actions: [
          IconButton(
              onPressed: () {
                controller.update(["marks_list"]);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => DropDownSelector<int>(
                        items: controller.yearsList
                            .map<DropDownItemValue<int>>(
                                (y) => DropDownItemValue(y, y.toString()))
                            .toList(),
                        value: controller.selectedYear.value,
                        title: "Year",
                        onChanged: (newYear) {
                          controller.selectYear(newYear);
                        },
                      )),
                  Obx(() => DropDownSelector<String>(
                      items: controller.classesController.classes
                          .map<DropDownItemValue<String>>(
                              (cls) => DropDownItemValue(cls.id, cls.name))
                          .toList(),
                      value: controller.selectedClass.value!.id,
                      title: "Class",
                      onChanged: (newClassId) {
                        controller.selectClass(newClassId);
                      })),
                  Obx(() => DropDownSelector<String>(
                      items: controller.subjectsController
                          .classesSubjects[controller.selectedClass.value!.id]!
                          .map<DropDownItemValue<String>>(
                              (sbj) => DropDownItemValue(sbj.id, sbj.name))
                          .toList(),
                      value: controller.selectedSubject.value!.id,
                      title: "Subject",
                      onChanged: (newSubjectId) {
                        controller.selectSubject(newSubjectId);
                      })),
                  Obx(() => DropDownSelector<int>(
                      items: controller.sequencesList
                          .map<DropDownItemValue<int>>((sequence) =>
                              DropDownItemValue(sequence, sequence.toString()))
                          .toList(),
                      value: controller.selectedSequence.value,
                      title: "Sequence",
                      onChanged: (sequence) {
                        controller.selectSequence(sequence);
                      })),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                        onPressed: () {
                          controller.saveAllMarks();
                        },
                        child: const Text("Save All")),
                  )
                ],
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "SN",
                        style: Get.textTheme.titleSmall,
                      ),
                    ),
                    Expanded(
                        flex: 7,
                        child: Text(
                          "Name",
                          style: Get.textTheme.titleSmall,
                        )),
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Mark",
                          style: Get.textTheme.titleSmall,
                        )),
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Total",
                          textAlign: TextAlign.center,
                          style: Get.textTheme.titleSmall,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "Action",
                          textAlign: TextAlign.center,
                          style: Get.textTheme.titleSmall,
                        ))
                  ],
                ),
              ),

              // Marks List

              Obx(() => StreamBuilder<List<Future<MarksModel>>>(
                  stream: MarksModel.getMarksStream(
                      controller.selectedClass.value!.ref,
                      controller.selectedSubject.value!.ref,
                      controller.selectedYear.value,
                      controller.selectedSequence.value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitDualRing(
                            color: Get.theme.colorScheme.primary),
                      );
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.book,
                                size: 56,
                              ),
                              SizedBox(height: 20),
                              Text("There are no Marks available for now"),
                            ],
                          ),
                        ),
                      );
                    }

                    final marksList = snapshot.data!;
                    return GetBuilder<MarksController>(
                      id: "marks_list",
                      builder: (controller) {
                        return ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return FutureBuilder<MarksModel>(
                                  future: marksList[index],
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      Fluttertoast.showToast(
                                          msg: snapshot.error.toString());
                                      return Text("${snapshot.error}");
                                    }
                                    if (snapshot.hasError ||
                                        !snapshot.hasData ||
                                        snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                      return const Center(
                                        child: SizedBox(
                                          width: double.maxFinite,
                                          child: Card(
                                            elevation: 4,
                                            child: Padding(
                                              padding: EdgeInsets.all(20),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    final mark = snapshot.data!;
                                    return Card(
                                      elevation: 4,
                                      child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text("${index + 1}"),
                                              ),
                                              Expanded(
                                                  flex: 7,
                                                  child: Text(
                                                      mark.student.fullName)),
                                              Expanded(
                                                  flex: 2,
                                                  child: TextField(
                                                    controller: controller
                                                                .marksControllersMap[
                                                            mark.id] ??
                                                        TextEditingController(
                                                            text: mark.value
                                                                ?.toString()),
                                                    textAlign: TextAlign.start,
                                                    onChanged: (val) {
                                                      if (controller
                                                                  .marksControllersMap[
                                                              mark.id] ==
                                                          null) {
                                                        controller.marksControllersMap[
                                                                mark.id] =
                                                            TextEditingController(
                                                                text: val);
                                                      } else {
                                                        controller
                                                            .marksControllersMap[
                                                                mark.id]!
                                                            .text = val;
                                                      }
                                                    },
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration:
                                                        const InputDecoration(
                                                            border:
                                                                UnderlineInputBorder()),
                                                  )),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    "${AppSettings.to.markTotal}",
                                                    textAlign: TextAlign.center,
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          tooltip: "Save Mark",
                                                          onPressed: () {
                                                            controller
                                                                .saveMarks(
                                                                    mark);
                                                          },
                                                          icon: const Icon(
                                                              Icons.save_alt,
                                                              size: 30))
                                                    ],
                                                  ))
                                            ],
                                          )),
                                    );
                                  });
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 20);
                            },
                            itemCount: marksList.length);
                      },
                    );
                  }))
            ],
          )),
    );
  }
}

class DropDownSelector<T> extends StatelessWidget {
  const DropDownSelector(
      {super.key,
      required this.items,
      required this.value,
      required this.title,
      required this.onChanged});

  final List<DropDownItemValue<T>> items;
  final T value;
  final String title;
  final void Function(T) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Get.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropdownButton<T>(
            underline: Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(20)),
            ),
            value: value,
            items: items
                .map<DropdownMenuItem<T>>((item) => DropdownMenuItem<T>(
                    value: item.value, child: Text(item.displayValue)))
                .toList(),
            onChanged: (newVal) {
              if (newVal == null) return;

              onChanged(newVal);
            })
      ],
    );
  }
}

class DropDownItemValue<T> {
  final T value;
  final String displayValue;

  const DropDownItemValue(this.value, this.displayValue);
}

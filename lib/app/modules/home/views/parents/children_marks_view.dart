import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/modules/home/controllers/children_marks_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/children_profile_controller.dart';

import '../../../../controllers/settings_controller.dart';
import '../admins/marks_view.dart';

class ChildrenMarksPage extends GetView<ChildrenMarksController> {
  const ChildrenMarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Children's Results"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.fetchCurrentChildMarks();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Obx(() => controller.currentChild.value == null
                      ? const SizedBox.shrink()
                      : DropDownSelector<String?>(
                          items: ChildrenProfileController.to.childrenList
                              .map<DropDownItemValue<String?>>(
                                  (y) => DropDownItemValue(y.id, y.fullName))
                              .toList(),
                          value: controller.currentChild.value?.id,
                          title: "Select Child",
                          onChanged: (selectedChild) {
                            if (selectedChild == null) return;

                            controller.selectChild(selectedChild);
                          },
                        )),
                  Obx(() => controller.currentChild.value == null
                      ? const SizedBox.shrink()
                      : DropDownSelector<int>(
                          items: controller.sequenceList
                              .map<DropDownItemValue<int>>(
                                  (s) => DropDownItemValue(s, s.toString()))
                              .toList(),
                          value: controller.selectedSequence.value,
                          title: "Sequence",
                          onChanged: (selectedSequence) {
                            controller.selectSequence(selectedSequence);
                          },
                        )),
                ],
              ),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "SN",
                        style: Get.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        flex: Get.width < 600 ? 5 : 7,
                        child: Text(
                          "Subject",
                          style: Get.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Mark",
                          style: Get.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        flex: 2,
                        child: Text(
                          "Total",
                          textAlign: TextAlign.center,
                          style: Get.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          Get.width <= 600 ? "Rm" : "Remark",
                          textAlign: TextAlign.center,
                          style: Get.textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              Obx(() => controller.isLoading.value
                  ? Center(
                      child:
                          SpinKitDualRing(color: Get.theme.colorScheme.primary),
                    )
                  : controller.currentChild.value == null ||
                          controller.childrenMarksMap[
                                  controller.currentChild.value!.id] ==
                              null ||
                          controller
                              .childrenMarksMap[
                                  controller.currentChild.value!.id]!
                              .isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 35.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.insert_drive_file_rounded, size: 56),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                  "The current child has no marks available for the moment.")
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final mark = controller.childrenMarksMap[
                                controller.currentChild.value!.id]![index];

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
                                          flex: Get.width < 600 ? 5 : 7,
                                          child: Text(mark.subject.name)),
                                      Expanded(
                                          flex: 2,
                                          child: Text("${mark.value ?? '-'}")),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "${AppSettings.to.markTotal}",
                                            textAlign: TextAlign.center,
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            mark.value == null
                                                ? 'Not uploaded'
                                                : mark.value! >=
                                                        ((mark.total ??
                                                                AppSettings.to
                                                                    .markTotal) /
                                                            2)
                                                    ? 'Passed'
                                                    : 'Failed',
                                            style: TextStyle(
                                                color: mark.value == null
                                                    ? Colors.black
                                                    : mark.value! >=
                                                            ((mark.total ??
                                                                    AppSettings
                                                                        .to
                                                                        .markTotal) /
                                                                2)
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          )),
                                    ],
                                  )),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 20);
                          },
                          itemCount: controller
                              .childrenMarksMap[
                                  controller.currentChild.value!.id]!
                              .length)),
              const SizedBox(height: 35),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Obx(() => controller.currentChild.value != null &&
                          controller.childrenMarksMap[
                                  controller.currentChild.value!.id] !=
                              null
                      ? SizedBox(
                          height: 30,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: [
                                Text(
                                    "Total Marks Obtained: ${controller.getStudentTotalMarkObtained()}",
                                    style: Get.textTheme.bodySmall!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 15),
                                Text(
                                    "Total Subject Marks: ${controller.getStudentTotalSubjectsMarks()}",
                                    style: Get.textTheme.bodySmall!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 15),
                                if (controller
                                    .childrenMarksMap[
                                        controller.currentChild.value!.id]!
                                    .isNotEmpty)
                                  Text(
                                      "Average: ${controller.getAverage().toStringAsFixed(2)}/20",
                                      style: Get.textTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.bold)),
                              ]),
                        )
                      : const SizedBox(
                          width: double.maxFinite,
                        )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

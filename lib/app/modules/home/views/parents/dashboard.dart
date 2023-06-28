import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/controllers/settings_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/children_marks_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/children_profile_controller.dart';
import 'package:student_tracker/app/utils/helpers.dart';

import '../../controllers/dashboard_controller.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Dashboard'),
            Text(
              "Welcome back ${AuthController.to.currentUser.value?.username ?? "User"}",
              style: Get.textTheme.titleSmall!
                  .copyWith(color: Get.theme.colorScheme.onPrimary),
            )
          ],
        ),
        actions: [
          if (Get.width > 600)
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.account_circle, size: 40),
            ),
          Obx(() => IconButton(
                icon: Icon(
                    AppSettings.to.currentThemeMode.value == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode),
                onPressed: () {
                  AppSettings.to.switchThemeMode();
                },
              )),
          if (Get.width <= 600)
            IconButton(
                onPressed: () {
                  AuthController.to.signOut();
                },
                icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overall Performance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Average Score',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => ChildrenMarksController.to.isLoading.value
                        ? Center(
                            child: SpinKitThreeInOut(
                              color: Get.theme.colorScheme.onPrimary,
                              size: 20,
                            ),
                          )
                        : FutureBuilder(
                            future: ChildrenMarksController.to
                                .calculateTotalAveragePerformance(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SpinKitThreeInOut(
                                    size: 20,
                                    color: Get.theme.colorScheme.onPrimary,
                                  ),
                                );
                              }

                              if (snapshot.hasError || !snapshot.hasData) {
                                return const Text(
                                  'Nothing to show for now',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }

                              final average = snapshot.data;
                              return Text(
                                average != null
                                    ? '${average.toStringAsFixed(1)}%'
                                    : 'Nothing to show for now',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            })),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Attendance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Column(
                children: [
                  ChildAttendanceCard(
                    childName: 'Cheng Zita',
                    attendancePercentage: 92,
                  ),
                  SizedBox(height: 8),
                  ChildAttendanceCard(
                    childName: 'Chenwi Paoul',
                    attendancePercentage: 85,
                  ),
                  SizedBox(height: 8),
                  ChildAttendanceCard(
                    childName: 'Alex Smith',
                    attendancePercentage: 78,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Recent Results',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => controller.lastUploadedResults.isEmpty ||
                      controller.isLoading.value
                  ? Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Obx(() => controller.isLoading.value
                            ? Center(
                                child: SpinKitThreeBounce(
                                  color: Get.theme.colorScheme.onSurface,
                                  size: 30,
                                ),
                              )
                            : const Text("No marks were uploaded recently")),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: controller.lastUploadedResults.keys.length,
                      itemBuilder: (context, index) {
                        final currentMarks = controller.lastUploadedResults[
                            controller.lastUploadedResults.keys
                                .toList()[index]];

                        return currentMarks == null
                            ? const Card(
                                elevation: 2,
                                child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child:
                                        Text("No marks are available for now")),
                              )
                            : currentMarks.isEmpty
                                ? Card(
                                    elevation: 2,
                                    child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                            "${ChildrenProfileController.to.childrenList.firstWhere((c) => c.id == controller.lastUploadedResults.keys.toList()[index]).fullName} has no recent results available")),
                                  )
                                : ResultCard(
                                    childName: currentMarks[0].student.fullName,
                                    subject: currentMarks[0].subject.name,
                                    score: '${currentMarks[0].value}/20',
                                    date:
                                        currentMarks[0].updated.visualFormat(),
                                  );
                      },
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

class ChildAttendanceCard extends StatelessWidget {
  final String childName;
  final int attendancePercentage;

  const ChildAttendanceCard({
    required this.childName,
    required this.attendancePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.person,
              size: 40,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Child: $childName',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Attendance: $attendancePercentage%',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final String childName;
  final String subject;
  final String score;
  final String date;

  const ResultCard({
    required this.childName,
    required this.subject,
    required this.score,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  Text(
                    'Child: $childName',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Subject: $subject',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Score: $score',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Date: $date',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

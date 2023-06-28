import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/modules/home/controllers/admin_dashboard_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/home_controller.dart';
import 'package:student_tracker/app/utils/helpers.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../controllers/settings_controller.dart';

class AdminDashboard extends GetView<AdminDashboardController> {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
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
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.initDashboard();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome, School Admin!',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashboardItem(
                    icon: Icons.people,
                    title: 'Students',
                    onTap: () {
                      HomeController.to.currentPageIndex.value = 1;
                    },
                  ),
                  DashboardItem(
                    icon: Icons.assignment,
                    title: 'Results',
                    onTap: () {
                      HomeController.to.currentPageIndex.value = 4;
                    },
                  ),
                  DashboardItem(
                    icon: Icons.book,
                    title: 'Subjects',
                    onTap: () {
                      HomeController.to.currentPageIndex.value = 2;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    Obx(() => controller.lastMarksUploaded.isNotEmpty
                        ? ActivityItem(
                            title:
                                'Uploaded Results for ${controller.lastMarksUploaded[0].subject.name}',
                            date: controller.lastMarksUploaded[0].updated
                                .visualFormat(),
                          )
                        : Card(
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
                                  : const Text(
                                      "No marks were uploaded recently")),
                            ),
                          )),
                    Obx(() => controller.lastStudentsUploaded.isNotEmpty
                        ? ActivityItem(
                            title:
                                'Added New Student - ${controller.lastStudentsUploaded[0].fullName}',
                            date: controller.lastStudentsUploaded[0].created
                                .visualFormat(),
                          )
                        : Card(
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
                                  : const Text(
                                      "No students were added recently")),
                            ),
                          )),
                    Obx(() => controller.lastSubjectsUploaded.isNotEmpty
                        ? ActivityItem(
                            title:
                                'Added a new suject - ${controller.lastSubjectsUploaded[0].name}',
                            date: controller.lastStudentsUploaded[0].created
                                .visualFormat(),
                          )
                        : Card(
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
                                  : const Text(
                                      "No subjects were added recently")),
                            ),
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DashboardItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback? onTap;

  const ActivityItem(
      {super.key, required this.title, required this.date, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            date,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

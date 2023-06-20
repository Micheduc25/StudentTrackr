import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Dashboard'),
            Text(
              "Welcome back ${AuthController.to.currentUser.value?.username ?? "User"}",
              style: Get.textTheme.titleSmall!
                  .copyWith(color: Get.theme.colorScheme.onPrimary),
            )
          ],
        ),
        actions: [
          CircleAvatar(
            radius: 40,
            child: Icon(Icons.account_circle, size: 40),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Performance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
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
                    Text(
                      'Average Score',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '85%',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Attendance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Column(
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
              SizedBox(height: 32),
              Text(
                'Recent Results',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  ResultCard(
                    childName: 'Cheng Zita',
                    subject: 'Mathematics',
                    score: '90%',
                    date: 'June 10, 2023',
                  ),
                  SizedBox(height: 8),
                  ResultCard(
                    childName: 'Chenwi Paoul',
                    subject: 'Science',
                    score: '95%',
                    date: 'June 12, 2023',
                  ),
                  SizedBox(height: 8),
                  ResultCard(
                    childName: 'Alex Smith',
                    subject: 'English',
                    score: '87%',
                    date: 'June 14, 2023',
                  ),
                ],
              ),
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
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Child: $childName',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
    );
  }
}

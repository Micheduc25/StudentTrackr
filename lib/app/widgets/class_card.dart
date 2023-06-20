import 'package:flutter/material.dart';
import 'package:student_tracker/app/models/class_model.dart';

class ClassCard extends StatelessWidget {
  final ClassModel classModel;
  final void Function(ClassModel) onEdit;
  final void Function(ClassModel) onDelete;

  const ClassCard({
    super.key,
    required this.classModel,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () => onEdit(classModel),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                classModel.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () => onEdit(classModel),
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () => onDelete(classModel),
                      icon: const Icon(Icons.delete)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

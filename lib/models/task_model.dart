import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  String tag;

  @HiveField(3)
  DateTime? dueDate;

  @HiveField(4)
  int priority; 


  TaskModel({required this.title,
    this.isDone = false,
    this.tag = '',
    this.dueDate,
    this.priority = 2,});
}

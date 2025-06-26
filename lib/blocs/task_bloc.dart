import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '../models/task_model.dart';

abstract class TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  AddTask(this.title);
}

class ToggleTask extends TaskEvent {
  final int index;
  ToggleTask(this.index);
}

class DeleteTask extends TaskEvent {
  final int index;
  DeleteTask(this.index);
}

class TaskState {
  final List<TaskModel> tasks;
  TaskState(this.tasks);
}

class AddTaskWithModel extends TaskEvent {
  final TaskModel task;
  AddTaskWithModel(this.task);
}

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Box<TaskModel> taskBox;

  TaskBloc(this.taskBox) : super(TaskState(taskBox.values.toList())) {
    on<AddTask>((event, emit) {
      taskBox.add(TaskModel(title: event.title));
      emit(TaskState(taskBox.values.toList()));
    });

    on<ToggleTask>((event, emit) {
      final task = taskBox.getAt(event.index)!;
      task.isDone = !task.isDone;
      task.save();
      emit(TaskState(taskBox.values.toList()));
    });

    on<DeleteTask>((event, emit) {
      taskBox.deleteAt(event.index);
      emit(TaskState(taskBox.values.toList()));
    });

    on<AddTaskWithModel>((event, emit) {
      taskBox.add(event.task);
      emit(TaskState(taskBox.values.toList()));
    });
  }
}


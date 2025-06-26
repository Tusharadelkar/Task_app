import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/theme_cubit.dart';
import '../blocs/task_bloc.dart';
import '../models/task_model.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (task.tag.isNotEmpty) Text("Tag: ${task.tag}"),
                      if (task.dueDate != null)
                        Text(
                          "Due: ${DateFormat.yMMMd().format(task.dueDate!)}",
                        ),
                      Text(
                        "Priority: ${["", "High", "Medium", "Low"].elementAt(task.priority.clamp(0, 3))}",
                      ),
                    ],
                  ),
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (_) {
                      context.read<TaskBloc>().add(ToggleTask(index));
                    },
                  ),
                  title: Text(
                    task.title,
                    style: task.isDone
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          )
                        : null,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<TaskBloc>().add(DeleteTask(index));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final tagController = TextEditingController();
    DateTime? selectedDate;
    int selectedPriority = 2;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Add Task"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Task Title"),
                ),
                TextField(
                  controller: tagController,
                  decoration: const InputDecoration(
                    labelText: "Tag (optional)",
                  ),
                ),
                Row(
                  children: [
                    const Text("Due Date: "),
                    Text(
                      selectedDate == null
                          ? "None"
                          : "${selectedDate?.toLocal()}".split(' ')[0],
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null)
                          setState(() => selectedDate = picked);
                      },
                    ),
                  ],
                ),
                DropdownButton<int>(
                  value: selectedPriority,
                  onChanged: (value) =>
                      setState(() => selectedPriority = value!),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("High Priority 🔴")),
                    DropdownMenuItem(
                      value: 2,
                      child: Text("Medium Priority 🟠"),
                    ),
                    DropdownMenuItem(value: 3, child: Text("Low Priority 🟢")),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                if (title.isNotEmpty) {
                  print("Creating task with date: $selectedDate");
                  final task = TaskModel(
                    title: title,
                    tag: tagController.text.trim(),
                    dueDate: selectedDate,
                    priority: selectedPriority,
                  );
                  context.read<TaskBloc>().add(AddTaskWithModel(task));
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/task_model.dart';
import 'blocs/task_bloc.dart';
import 'pages/home_page.dart';
import 'theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  final taskBox = await Hive.openBox<TaskModel>('tasksBox');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TaskBloc(taskBox)),
        BlocProvider(create: (_) => ThemeCubit()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
 
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Task App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}

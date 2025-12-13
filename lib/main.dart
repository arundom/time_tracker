import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart' as lstore;
import 'package:provider/provider.dart';

import 'providers/time_entry_provider.dart';
import 'screens/project_management_screen.dart';
import 'screens/home_screen.dart';
import 'screens/task_management_screen.dart';


/*
bool _initialized = false;
late LocalStorage _localStorage;

/// Initialize the [LocalStorage].
Future<void> initLocalStorage() async {
  if (_initialized) return;

  _localStorage = await init();
  _initialized = true;
}

/// Get the instance of [LocalStorage].
LocalStorage get localStorage {
  if (_initialized) return _localStorage;
  return _localStorage;
}
*/

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await lstore.initLocalStorage();  
  // await lstore.LocalStorage.ready;

  runApp(MyApp(lstorage: lstore.localStorage));
  
}

class MyApp extends StatelessWidget {
  
  final lstore.LocalStorage lstorage;    
  const MyApp({Key? key, required this.lstorage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>  TimeEntryProvider(lstorage)),
      ],
      child: MaterialApp(
        title: 'Time Tracker',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(), // Main entry point, HomeScreen
          '/manage_projects': (context) => ProjectManagementScreen(), // Route for managing projects
          '/manage_tasks': (context) => TaskManagementScreen(), // Route for managing tasks
        },
        // Removed 'home:' since 'initialRoute' is used to define the home route
      ),
    );
  }
}
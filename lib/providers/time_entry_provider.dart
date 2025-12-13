import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/main.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/models/task.dart';
import 'package:time_tracker/models/time_entry.dart';


class TimeEntryProvider with ChangeNotifier {
  
  final LocalStorage storage;

  //TimeEntryProvider(this.storage);
  
// List of time entries
  List<TimeEntry> _entries = [];

  
// So here the variable entries is accessed like a property, not a method.
// And the variable _entries is private to this class.


// List of projects
  late List<Project> _projects;
  
  /*
  = [
    Project(id: '1', name: 'MBA', isDefault: true),
    Project(id: '2', name: 'WordPress', isDefault: true),
    Project(id: '3', name: 'Flutter', isDefault: true),
    Project(id: '4', name: 'Artificial Intelligence', isDefault: true),
    Project(id: '5', name: 'PMP', isDefault: true), 
    ];  // List of projects
  */

  late List<Task> _tasks ;
  /*
  = [
    Task(id: '1', name: 'Read'),
    Task(id: '2', name: 'Take Notes'),
    Task(id: '3', name: 'Take Exam'),
    Task(id: '4', name: 'Project Work'),
    ];

*/
  // Getters
  List<TimeEntry> get entries => _entries;
  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;

   TimeEntryProvider(this.storage) {
    loadProjectsFromStorage();
    loadTasksFromStorage();
    loadEntriesFromStorage();  // Add this line
}
   
  

// Load Time Entries from storage
  void loadEntriesFromStorage() {
    try {
      var storedEntries = storage.getItem('time_entries');
      if (storedEntries != null) {
        List<dynamic> decoded = jsonDecode(storedEntries);
        _entries = decoded.map((item) => TimeEntry.fromJson(item)).toList();
        notifyListeners();
      } else {
        _entries = []; // Initialize to empty list if no entries found
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load time entries from storage: $e');
      }
      _entries = []; // Initialize to empty list on error
    }
  }


// Load Tasks from storage
  void loadTasksFromStorage() {
    try {
      var storedTasks = storage.getItem('tasks');
      if (storedTasks != null) {
        List<dynamic> decoded = jsonDecode(storedTasks);
        _tasks = decoded.map((item) => Task.fromJson(item)).toList();
        notifyListeners();
      } else {
        _tasks = []; // Initialize to empty list if no tasks found
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load tasks from storage: $e');
      }
      _tasks = []; // Initialize to empty list on error
    }
  } 
// Save Tasks to storage - used in addTask and deleteTask

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveEntriesToStorage();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveEntriesToStorage();   
    notifyListeners();
  }

// Add project
  void addProject(Project project) {
    if (!_projects.any((cat) => cat.name == project.name)) {
      _projects.add(project);
     _saveProjectToStorage();  
      notifyListeners();
    }
  }

  // Delete a category
  void deleteProject(String id) {
    _projects.removeWhere((proj) => proj.id == id);
    _saveProjectToStorage();
    notifyListeners();
  }
void _saveProjectToStorage() {
    storage.setItem(
        'projects', jsonEncode(_projects.map((c) => c.toJson()).toList()));
  }

  // Load Projects from storage
void loadProjectsFromStorage() {
    try {
      
      var storedProjects = storage.getItem('projects');
      
      if (storedProjects != null) {
        List<dynamic> decoded = jsonDecode(storedProjects);
        _projects = decoded.map((item) => Project.fromJson(item)).toList();
        notifyListeners();
      } else {
        _projects = []; // Initialize to empty list if no projects found
      }
    
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load projects from storage: $e');
      }
      _projects = []; // Initialize to empty list on error
    }
  } 
  


// Add a Task
  void addTask(Task task) {
    if (!_tasks.any((cat) => cat.name == task.name)) {
      _tasks.add(task);
     _saveTasksToStorage();       
      notifyListeners();
    }
  }

  // Delete a category
  void deleteTasks(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveProjectToStorage();
    notifyListeners();
  }

 void _saveTasksToStorage() {
    storage.setItem(
        'tasks', jsonEncode(_tasks.map((t) => t.toJson()).toList()));
  }
  
  void _saveEntriesToStorage() {
    storage.setItem(
        'time_entries', jsonEncode(_entries.map((e) => e.toJson()).toList()));  
  }

}

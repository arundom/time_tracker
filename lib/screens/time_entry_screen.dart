import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/providers/time_entry_provider.dart';
import 'package:time_tracker/models/time_entry.dart';
import 'package:time_tracker/widgets/add_project_dialog.dart';
import 'package:time_tracker/widgets/add_task_dialog.dart';
import '../providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  
  //String projectId = '';
  //String taskId='';
  double totalTime = 0.0;
  //DateTime date = DateTime.now();
  String notes = '';

  String? _selectedProjectId;
  String? _selectedTaskId;
  DateTime _selectedDate = DateTime.now();

/*
final TimeEntry = TimeEntry(
      id: widget.?.id ??
          DateTime.now().toString(), // Assuming you generate IDs like this
      amount: double.parse(_amountController.text),
      categoryId: _selectedCategoryId!,
      payee: _payeeController.text,
      note: _noteController.text,
      date: _selectedDate,
      tag: _selectedTagId!,
    );
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.green[800],
         foregroundColor: Colors.white,
         centerTitle: true,
        title: Text('Add Time Entry'),
      ),

  body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
        
        child: Column(
          children: [

            // Project drop down                        
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 20.0), // Adjust the padding as needed
              child: buildProjectDropdown(Provider.of<TimeEntryProvider>(context),
            ),  ),

/*
            DropdownButtonFormField<String>(
                //initialValue: projectId,
                onChanged: (String? newValue) {
                setState(() {
                    projectId = newValue!;
                });
                },

                decoration: InputDecoration(labelText: 'Project'),
                items: <String>['Project 1', 'Project 2', 'Project 3'] // Dummy project names
                    .map<DropdownMenuItem<String>>((String value) {
                
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                );
            
                }).toList(),
            
            ),
          */
          // Project drop down                        
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 20.0), // Adjust the padding as needed
              child: buildTaskDropdown(Provider.of<TimeEntryProvider>(context),
            ),  ),
/*
            DropdownButtonFormField<String>(
            //    initialValue: taskId,
                onChanged: (String? newValue) {
                setState(() {
                    _selectedTaskId = newValue!;
                });
                },

                decoration: InputDecoration(labelText: 'Task'),                
                items: <String>['Task 1', 'Task 2', 'Task 3'] // Dummy task names
                    .map<DropdownMenuItem<String>>((String value) {
                
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                );
                
                }).toList(),
            ),
*/
            TextFormField(
                decoration: InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                if (value == null || value.isEmpty) {
                    return 'Please enter total time';
                }
                if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                }
                return null;
                },
                onSaved: (value) => totalTime = double.parse(value!),
            ),
            TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                validator: (value) {
                if (value == null || value.isEmpty) {
                    return 'Please enter some notes';
                }
                return null;
                },
                onSaved: (value) => notes = value!,
            ),
            ElevatedButton(
                onPressed: () {
                
                if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<TimeEntryProvider>(context, listen: false)
                        .addTimeEntry(TimeEntry(
                        id: DateTime.now().toString(), // Simple ID generation
                        projectId: _selectedProjectId?? '',
                        taskId: _selectedTaskId?? '',
                        totalTime: totalTime,
                        date: _selectedDate,
                        notes: notes,
                        ));
                    Navigator.pop(context);
                }
                },
                child: Text('Save'),
            )
            
           ],
        ),
        ),
    
  )
    );
  }


// Helper method to build the project dropdown
  Widget buildProjectDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedProjectId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddProjectDialog(onAdd: (newProject) {
              setState(() {
                _selectedProjectId =
                    newProject.id; // Automatically select the new category
                provider.addProject(
                    newProject); // Add to provider, assuming this method exists
              });
            }),
          );
        } else {
          setState(() => _selectedProjectId = newValue);
        }
      },
      items: provider.projects.map<DropdownMenuItem<String>>((category) {
        return DropdownMenuItem<String>(
          value: category.id,
          child: Text(category.name),
        );
      }).toList()
        ..add(DropdownMenuItem(
          value: "New",
          child: Text("Add New Project"),
        )),
      decoration: InputDecoration(
        labelText: 'Project',
        border: OutlineInputBorder(),
      ),
    );
  }

// Helper method to build the tag dropdown
  Widget buildTaskDropdown(TimeEntryProvider provider) {
    return DropdownButtonFormField<String>(
      value: _selectedTaskId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(onAdd: (newTask) {
              provider.addTask(newTask); // Assuming you have an `addTag` method.
              setState(() => _selectedTaskId = newTask.id); // Update selected tag ID
            }),
          );
        } else {
          setState(() => _selectedTaskId = newValue);
        }
      },
      items: provider.tasks.map<DropdownMenuItem<String>>((tag) {
        return DropdownMenuItem<String>(
          value: tag.id,
          child: Text(tag.name),
        );
      }).toList()
        ..add(DropdownMenuItem(
          value: "New",
          child: Text("Add New Task"),
        )),
      decoration: InputDecoration(
        labelText: 'Task',
        border: OutlineInputBorder(),
      ),
    );
  }

}
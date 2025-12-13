import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../models/task.dart';

class TaskManagementScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {

           return ListView.builder(
            
            itemCount: provider.tasks.length,
            
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return ListTile(
                title: Text(task.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete the task
                    provider.deleteTasks(task.id);
                  },
                ),
              );
            },

          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new task
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(
              onAdd: (newTask) {
                Provider.of<TimeEntryProvider>(context, listen: false).addTask(newTask);
                // Close the dialog after adding the new tag
                //Navigator.pop(context); 
              },
            ),
          );

        },
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
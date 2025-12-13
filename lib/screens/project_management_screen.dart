import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import '../widgets/add_project_dialog.dart';
import '../models/project.dart';

class ProjectManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
          backgroundColor: Colors.deepPurple[800],
          foregroundColor: Colors.white,
          centerTitle: true,
        title: Text('Manage Projects'),
      ),

      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          
          return ListView.builder(
            
            itemCount: provider.projects.length,
            
            itemBuilder: (context, index) {
              final Project = provider.projects[index];
              return ListTile(
                title: Text(Project.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteProject(Project.id);
                  },
                ),
              );
            },

          );  
                    // Lists for managing projects would be implemented here

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          // Add new project          
          
          showDialog(
            context: context,
            builder: (context) => AddProjectDialog(
              onAdd: (newProject) {
                Provider.of<TimeEntryProvider>(context, listen: false)
                    .addProject(newProject);
                //Navigator.pop(context); // Close the dialog
              },
            ),
          );
        

          //asdsd
        },
        child: Icon(Icons.add),
        tooltip: 'Add Project',
      ),
    );
  }
}
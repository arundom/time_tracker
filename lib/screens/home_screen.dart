import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/models/task.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';
import '../screens/time_entry_screen.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'All Entries'),
    Tab(text: 'Grouped By Projects'),
  ];

 // late TabController _tabController;

/*
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: myTabs.length, 
    child:Scaffold(
      appBar: AppBar(
        title: Text('Time Tracking'),
          backgroundColor: Colors.deepPurple[800],
          foregroundColor: Colors.white,
          centerTitle: true,
          
          bottom: TabBar(
             //controller: _tabController,
             indicatorColor: Colors.white,
             labelColor: Colors.white,
             unselectedLabelColor: Colors.white70,
              tabs: myTabs,
          ),
      
      ),
      
       drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.deepPurple),
              title: Text('Manage Projects'),
              onTap: () {
               // Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
            ListTile(
              leading: Icon(Icons.tag, color: Colors.deepPurple),
              title: Text('Manage Tasks'),
              onTap: () {
                // Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
          ],
        ),
      ),

      body: TabBarView(
            children: [
              // First tab - All Entries (your current view)
              buildAllEntriesView(),
              
              // Second tab - Grouped By Projects (new view)
              buildGroupedByProjectsView(),
            ],
        ),



/*
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {

           if (provider.entries.isEmpty) {
               return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("No time entries yet.", style: TextStyle(color: Colors.grey[700], fontSize: 18)),
                      SizedBox(height: 8),
                      Text("Tap the + button to add your first time entry.", style: TextStyle(color: Colors.grey[600])),
                      SizedBox(height: 8),
                      Text("You can manage projects and tasks from the menu.", style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                );
              } 

          return ListView.builder(
            itemCount: provider.entries.length,
           
            itemBuilder: (context, index) {
              final entry = provider.entries[index];

              // Find the project object by ID
              final project = provider.projects.firstWhere(
                (p) => p.id == entry.projectId,
                orElse: () => Project(id: '', name: 'Unknown Project', isDefault: false),
              );

              // Find the task object by ID
              final task = provider.tasks.firstWhere(
                (t) => t.id == entry.taskId,
                orElse: () => Task(id: '', name: 'Unknown Task'),
              );

              return ListTile(
                title: Text('${project.name} -${task.name} -${entry.totalTime} hours'),
                subtitle: Text( 'Date: ${DateFormat('MMM dd, yyyy').format(entry.date)} - Notes: ${entry.notes}'),
                
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete time entry
                    provider.deleteTimeEntry(entry.id);                    
                  },
                ),
                onTap: () {
                  // This could open a detailed view or edit screen
                },
              );
            },
          );
        },
      ),
      */
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          // Navigate to the screen to add a new time entry
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Time Entry',
      ),
    )
    );
    
  }

Widget buildAllEntriesView() {
  return Consumer<TimeEntryProvider>(
    builder: (context, provider, child) {
      if (provider.entries.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("No time entries yet.", style: TextStyle(color: Colors.grey[700], fontSize: 18)),
              SizedBox(height: 8),
              Text("Tap the + button to add your first time entry.", style: TextStyle(color: Colors.grey[600])),
              SizedBox(height: 8),
              Text("You can manage projects and tasks from the menu.", style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: provider.entries.length,
        itemBuilder: (context, index) {
          final entry = provider.entries[index];
          final project = provider.projects.firstWhere(
            (p) => p.id == entry.projectId,
            orElse: () => Project(id: '', name: 'Unknown Project', isDefault: false),
          );
          final task = provider.tasks.firstWhere(
            (t) => t.id == entry.taskId,
            orElse: () => Task(id: '', name: 'Unknown Task'),
          );

          return ListTile(
            title: Text('${project.name} - ${task.name} - ${entry.totalTime} hours'),
            subtitle: Text('Date: ${DateFormat('MMM dd, yyyy').format(entry.date)} - Notes: ${entry.notes}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                provider.deleteTimeEntry(entry.id);
              },
            ),
            onTap: () {
              // This could open a detailed view or edit screen
            },
          );
        },
      );
    },
  );
}

Widget buildGroupedByProjectsView() {
  return Consumer<TimeEntryProvider>(
    builder: (context, provider, child) {
      if (provider.entries.isEmpty) {
        return Center(child: Text("No entries to group.", style: TextStyle(color: Colors.grey[600])));
      }

      // Group entries by project
      Map<String, List<TimeEntry>> grouped = {};
      for (var entry in provider.entries) {
        grouped.putIfAbsent(entry.projectId, () => []).add(entry);
      }

      return ListView(
        
        children: grouped.entries.map((mapEntry) {
          final projectId = mapEntry.key;
          final entries = mapEntry.value;
          
          final project = provider.projects.firstWhere(
            (p) => p.id == projectId,
            orElse: () => Project(id: '', name: 'Unknown Project', isDefault: false),
          );
          
          double totalHours = entries.fold(0.0, (sum, e) => sum + e.totalTime);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '${project.name} - Total: $totalHours hours',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ),
              ...entries.map((entry) {
                final task = provider.tasks.firstWhere(
                  (t) => t.id == entry.taskId,
                  orElse: () => Task(id: '', name: 'Unknown Task'),
                );
                return ListTile(
                  leading: Icon(Icons.access_time, color: Colors.deepPurple),
                  title: Text('${task.name} - ${entry.totalTime} hours'),
                  subtitle: Text('${DateFormat('MMM dd, yyyy').format(entry.date)} - ${entry.notes}'),
                );
              }).toList(),
              Divider(),
            ],
          );
        }).toList(),
      );
    },
  );
}



}
import 'package:provider/provider.dart';
import 'package:time_tracker/models/time_entry.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../providers/time_entry_provider.dart';

class AddTaskDialog extends StatefulWidget {
  
  final Function(Task) onAdd;

  AddTaskDialog({required this.onAdd});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Task'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Task Name',
        ),
      ),
      actions: [
        
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        
        TextButton(
          child: Text('Add'),
          onPressed: () {
            
            var newTag = Task(id: DateTime.now().toString(), name: _controller.text);

            widget.onAdd(newTag);
            
            // Update the provider and UI
            Provider.of<TimeEntryProvider>(context, listen: false).addTask(newTag);
            
            // Clear the input field for next input            
            _controller.clear();

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
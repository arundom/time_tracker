class Task {
  final String id;
  final String name;

  Task({required this.id, required this.name});

// Convert a JSON object to an ExpenseCategory instance
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],      
    );
  }

  // Convert an ExpenseCategory instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,     
    };
  }


}
 
// Define the Chat class to represent a chat object
class Chat {
  final String empId;
  String description;
  final String time;

  Chat({
    required this.empId,
    required this.description,
    required this.time,
  });

  // Factory method to create a Chat object from JSON data
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      empId: json['empid'] as String,
      description: json['description'] as String,
      time: json['time'] as String,
    );
  }
}
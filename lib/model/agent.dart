class Agent {
  final String name;
  final String location;
  final String phoneNumber;

  Agent(
      {required this.name, required this.location, required this.phoneNumber});

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      name: json['name'],
      location: json['telegram'],
      phoneNumber: json['whats_app'],
    );
  }
}

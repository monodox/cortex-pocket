import 'package:flutter/material.dart';

class PersonaSelectorScreen extends StatefulWidget {
  const PersonaSelectorScreen({super.key});

  @override
  State<PersonaSelectorScreen> createState() => _PersonaSelectorScreenState();
}

class _PersonaSelectorScreenState extends State<PersonaSelectorScreen> {
  String selectedPersona = 'Helper';

  final List<Map<String, dynamic>> personas = [
    {'name': 'Helper', 'icon': Icons.help, 'description': 'General assistance'},
    {'name': 'Developer', 'icon': Icons.code, 'description': 'Code analysis & debugging'},
    {'name': 'Security', 'icon': Icons.security, 'description': 'Security analysis'},
    {'name': 'Writer', 'icon': Icons.edit, 'description': 'Content creation'},
    {'name': 'Analyst', 'icon': Icons.analytics, 'description': 'Data analysis'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Persona')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: personas.length,
        itemBuilder: (context, index) {
          final persona = personas[index];
          return Card(
            child: ListTile(
              leading: Icon(persona['icon'], color: Colors.blue),
              title: Text(persona['name']),
              subtitle: Text(persona['description']),
              trailing: Icon(
                selectedPersona == persona['name'] ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selectedPersona == persona['name'] ? Colors.blue : Colors.grey,
              ),
              onTap: () => setState(() => selectedPersona = persona['name']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context, selectedPersona),
        child: const Icon(Icons.check),
      ),
    );
  }
}
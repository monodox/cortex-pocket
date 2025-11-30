class Persona {
  final String name;
  final String description;
  final String systemPrompt;
  final String icon;

  const Persona({
    required this.name,
    required this.description,
    required this.systemPrompt,
    required this.icon,
  });
}

class PersonaRepository {
  static final PersonaRepository _instance = PersonaRepository._internal();
  factory PersonaRepository() => _instance;
  PersonaRepository._internal();

  final List<Persona> _personas = [
    Persona(
      name: 'Helper',
      description: 'General assistance',
      systemPrompt: 'You are a helpful AI assistant.',
      icon: 'help',
    ),
    Persona(
      name: 'Developer',
      description: 'Code analysis & debugging',
      systemPrompt: 'You are an expert software developer. Focus on code quality, best practices, and debugging.',
      icon: 'code',
    ),
    Persona(
      name: 'Security',
      description: 'Security analysis',
      systemPrompt: 'You are a cybersecurity expert. Analyze code and systems for vulnerabilities and security issues.',
      icon: 'security',
    ),
    Persona(
      name: 'Writer',
      description: 'Content creation',
      systemPrompt: 'You are a professional writer. Help with content creation, editing, and writing improvement.',
      icon: 'edit',
    ),
    Persona(
      name: 'Analyst',
      description: 'Data analysis',
      systemPrompt: 'You are a data analyst. Help analyze data, create insights, and explain complex information.',
      icon: 'analytics',
    ),
  ];

  List<Persona> getAllPersonas() => List.unmodifiable(_personas);

  Persona? getPersonaByName(String name) {
    try {
      return _personas.firstWhere((p) => p.name == name);
    } catch (e) {
      return null;
    }
  }

  String getSystemPrompt(String personaName) {
    final persona = getPersonaByName(personaName);
    return persona?.systemPrompt ?? _personas.first.systemPrompt;
  }
}
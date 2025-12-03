import 'package:flutter/material.dart';
import '../../core/routes.dart';
import '../../services/llm_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  final String _modelPath = '/storage/models/';
  double _cacheSize = 2.1;
  final TextEditingController _apiKeyController = TextEditingController();
  final LLMService _llmService = LLMService();
  bool _isTestingKey = false;
  String? _testResult;
  bool _isEditingKey = false;

  @override
  void initState() {
    super.initState();
    _llmService.addListener(_onLLMServiceChanged);
  }

  @override
  void dispose() {
    _llmService.removeListener(_onLLMServiceChanged);
    _apiKeyController.dispose();
    super.dispose();
  }

  void _onLLMServiceChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _saveAndTestApiKey() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      setState(() => _testResult = 'Please enter an API key');
      return;
    }
    
    setState(() {
      _isTestingKey = true;
      _testResult = 'Testing API key...';
    });

    try {
      // Basic format validation for multiple providers
      bool isValidFormat = apiKey.startsWith('sk-') ||           // OpenAI
                          apiKey.startsWith('AIza') ||          // Gemini
                          apiKey.startsWith('gsk_') ||          // Groq
                          apiKey.startsWith('anthropic-');      // Anthropic
      
      if (!isValidFormat || apiKey.length < 20) {
        setState(() => _testResult = 'Invalid format: API key should start with sk-, AIza, gsk_, or anthropic-');
        return;
      }

      final isValid = await _llmService.testApiKey(apiKey);
      if (isValid) {
        await _llmService.saveApiKey(apiKey);
        setState(() => _testResult = 'API key saved successfully');
        _apiKeyController.clear();
      } else {
        setState(() => _testResult = 'API key validation failed - check key and network');
      }
    } catch (e) {
      setState(() => _testResult = 'Test failed: ${e.toString()}');
    } finally {
      setState(() => _isTestingKey = false);
    }
  }

  Future<void> _editApiKey() async {
    setState(() {
      _isEditingKey = true;
      _testResult = null;
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditingKey = false;
      _apiKeyController.clear();
      _testResult = null;
    });
  }

  Future<void> _deleteApiKey() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete API Key'),
        content: const Text('Are you sure you want to delete the stored API key? This will disable remote mode.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _llmService.clearApiKey();
      setState(() => _testResult = 'API key deleted');
    }
  }

  Future<void> _showRemoteConsentDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Remote Mode'),
        content: const Text(
          'When enabled, your messages will be sent to the remote API provider. '
          'This provides access to more powerful models but reduces privacy. '
          'You can disable this anytime.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _llmService.setUseRemote(true);
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Model Storage Path'),
            subtitle: Text(_modelPath),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Cache Size'),
            subtitle: Text('${_cacheSize.toStringAsFixed(1)} GB'),
            trailing: TextButton(
              onPressed: () => setState(() => _cacheSize = 0),
              child: const Text('Clear'),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.cloud),
            title: Text('Remote API'),
            subtitle: Text('Optional cloud-based inference'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_llmService.hasApiKey || _isEditingKey)
                  TextField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      labelText: 'API Key',
                      hintText: 'Enter your API key',
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isEditingKey)
                            TextButton(
                              onPressed: _cancelEdit,
                              child: const Text('Cancel'),
                            ),
                          if (_isTestingKey)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            TextButton(
                              onPressed: _saveAndTestApiKey,
                              child: const Text('Save & Test'),
                            ),
                        ],
                      ),
                    ),
                    obscureText: true,
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'API Key configured',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        TextButton(
                          onPressed: _editApiKey,
                          child: const Text('Edit'),
                        ),
                        TextButton(
                          onPressed: _deleteApiKey,
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                if (_testResult != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _testResult!,
                      style: TextStyle(
                        color: _testResult!.contains('success') ? Colors.green : Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.cloud_queue),
            title: const Text('Use Remote API'),
            subtitle: Text(_llmService.hasApiKey ? 'API key configured' : 'Requires API key'),
            value: _llmService.useRemote,
            onChanged: _llmService.hasApiKey ? (value) {
              if (value) {
                _showRemoteConsentDialog();
              } else {
                _llmService.setUseRemote(false);
              }
            } : null,
          ),
          if (_llmService.hasApiKey)
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete API Key', style: TextStyle(color: Colors.red)),
              subtitle: const Text('Remove stored API key and disable remote mode'),
              onTap: _deleteApiKey,
            ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Notice'),
            subtitle: Text('Remote mode sends messages to external providers'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.gavel),
            title: Text('Legal'),
            subtitle: Text('Privacy, terms, and policies'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () => Navigator.pushNamed(context, Routes.privacy),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Use'),
            onTap: () => Navigator.pushNamed(context, Routes.terms),
          ),
          ListTile(
            leading: const Icon(Icons.cookie),
            title: const Text('Cookie Policy'),
            onTap: () => Navigator.pushNamed(context, Routes.cookies),
          ),
          ListTile(
            leading: const Icon(Icons.smart_toy),
            title: const Text('AI Disclaimer'),
            onTap: () => Navigator.pushNamed(context, Routes.aiDisclaimer),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () => Navigator.pushNamed(context, Routes.about),
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report Issue'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
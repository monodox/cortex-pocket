import 'package:flutter/material.dart';
import '../../core/routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  String _modelPath = '/storage/models/';
  double _cacheSize = 2.1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.folder),
            title: Text('Model Storage Path'),
            subtitle: Text(_modelPath),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text('Cache Size'),
            subtitle: Text('${_cacheSize.toStringAsFixed(1)} GB'),
            trailing: TextButton(
              onPressed: () => setState(() => _cacheSize = 0),
              child: Text('Clear'),
            ),
          ),
          SwitchListTile(
            secondary: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Settings'),
            subtitle: Text('All processing is local'),
            trailing: Icon(Icons.check_circle, color: Colors.green),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () => Navigator.pushNamed(context, Routes.about),
          ),
          ListTile(
            leading: Icon(Icons.bug_report),
            title: Text('Report Issue'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
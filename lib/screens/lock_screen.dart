import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/auth_service.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _authService = AuthService();
  String? _selectedFolder;
  final TextEditingController _keyController = TextEditingController();

  Future<void> _pickFolder() async {
    String? selectedPath = await FilePicker.platform.getDirectoryPath();
    if (selectedPath != null) {
      setState(() {
        _selectedFolder = selectedPath;
      });
    }
  }

  void _lockFolder() async {
    if (_selectedFolder == null || _keyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Select folder and enter encryption key")),
      );
      return;
    }

    final response = await _authService.lockFolder(_selectedFolder!, _keyController.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lock Folder")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextButton(
              onPressed: _pickFolder,
              child: Text("Select Folder"),
            ),
            Text(_selectedFolder ?? "No folder selected"),
            TextField(
              controller: _keyController,
              decoration: InputDecoration(labelText: "Encryption Key"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _lockFolder,
              child: Text("Lock Folder"),
            ),
          ],
        ),
      ),
    );
  }
}

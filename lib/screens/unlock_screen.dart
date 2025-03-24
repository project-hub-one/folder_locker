import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class UnlockScreen extends StatefulWidget {
  @override
  _UnlockScreenState createState() => _UnlockScreenState();
}

class _UnlockScreenState extends State<UnlockScreen> {
  final _authService = AuthService();
  List<dynamic> _lockedFolders = [];
  final TextEditingController _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLockedFolders();
  }

  Future<void> _fetchLockedFolders() async {
    final folders = await _authService.getLockedFolders();
    setState(() {
      _lockedFolders = folders;
    });
  }

  void _unlockFolder(int folderId) async {
    if (_keyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter encryption key")),
      );
      return;
    }

    final response = await _authService.unlockFolder(folderId, _keyController.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'])));

    if (response['status'] == 'success') {
      _fetchLockedFolders(); // Refresh the list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Unlock Folder")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _keyController,
              decoration: InputDecoration(labelText: "Encryption Key"),
              obscureText: true,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _lockedFolders.length,
                itemBuilder: (context, index) {
                  final folder = _lockedFolders[index];
                  return ListTile(
                    title: Text(folder['folder_path']),
                    trailing: IconButton(
                      icon: Icon(Icons.lock_open),
                      onPressed: () => _unlockFolder(folder['folder_id']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

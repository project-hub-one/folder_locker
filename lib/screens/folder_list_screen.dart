import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:folder_locker/services/auth_service.dart';

class FolderListScreen extends StatefulWidget {
  @override
  _FolderListScreenState createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  final _authService = AuthService();
  List<dynamic> _lockedFolders = [];

  @override
  void initState() {
    super.initState();
    _loadLockedFolders(); // Fetch locked folders
  }

  // 🔹 Fetch locked folders from API
  Future<void> _loadLockedFolders() async {
    final folders = await _authService.getLockedFolders();
    setState(() {
      _lockedFolders = folders;
    });
  }

  // 🔹 Pick a folder and lock it
  Future<void> _pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    
    if (selectedDirectory != null) {
      print("📁 Selected Folder: $selectedDirectory");
      _lockFolder(selectedDirectory);
    }
  }

  // 🔹 Lock folder API call
  Future<void> _lockFolder(String folderPath) async {
    final encryptionKey = "my_secure_key"; // Replace with user input if needed
    final response = await _authService.lockFolder(folderPath, encryptionKey);
    
    if (response['status'] == 'success') {
      _loadLockedFolders(); // Refresh list
    }
  }
    Future<void> _lockFolderen(String folderPath) async {
    final encryptionKey = "my_secure_key"; // Replace with user input if needed
    final response = await _authService.lockFolderen(folderPath, encryptionKey);
    
    if (response['status'] == 'success') {
      _loadLockedFolders(); // Refresh list
    }
  }

  // 🔹 Unlock folder API call
  Future<void> _unlockFolder(int folderId) async {
    final encryptionKey = "my_secure_key"; // Replace with user input
    final response = await _authService.unlockFolder(folderId, encryptionKey);
    
    if (response['status'] == 'success') {
      _loadLockedFolders(); // Refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Locked Folders")),
      body: _lockedFolders.isEmpty
          ? Center(child: Text("No locked folders yet"))
          : ListView.builder(
              itemCount: _lockedFolders.length,
              itemBuilder: (context, index) {
                final folder = _lockedFolders[index];
                return ListTile(
                  title: Text("Folder " + folder['folder_id'].toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.lock_open, color: Colors.red),
                        onPressed: () => _lockFolderen(folder['folder_path']), // 🔒 Re-lock folder
                      ),
                      IconButton(
                        icon: Icon(Icons.lock, color: Colors.green),
                        onPressed: () => _unlockFolder(folder['folder_id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFolder,
        child: Icon(Icons.folder),
      ),
    );
  }
}

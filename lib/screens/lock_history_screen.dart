import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LockHistoryScreen extends StatefulWidget {
  @override
  _LockHistoryScreenState createState() => _LockHistoryScreenState();
}

class _LockHistoryScreenState extends State<LockHistoryScreen> {
  List<dynamic> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final fetchedHistory = await AuthService().getLockHistory();
    setState(() {
      history = fetchedHistory;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lock/Unlock History")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : history.isEmpty
              ? Center(child: Text("No history available"))
              : ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return ListTile(
                      leading: Icon(
                        item['action'] == 'LOCK' ? Icons.lock : Icons.lock_open,
                        color: item['action'] == 'LOCK' ? Colors.red : Colors.green,
                      ),
                      title: Text("Folder ID: ${item['folder_id']}"),
                      subtitle: Text("Action: ${item['action']}"),
                      trailing: Text(item['action_time']),
                    );
                  },
                ),
    );
  }
}

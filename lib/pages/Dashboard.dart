import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dashboard/main.dart';
import 'package:dashboard/pages/AddPerson.dart';
import 'package:dashboard/pages/update.dart';
import 'db_helper.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> contacts = [];
  List<Map<String, dynamic>> filteredContacts = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts(); 
  }

  Future<void> _fetchContacts() async {
    final data = await DBHelper().getContacts();
    setState(() {
      contacts = data;
      filteredContacts = contacts; 
    });
  }

  Future<void> _makeDirectCall(String phoneNumber) async {
    //final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);

   // await launchUrl(phoneUri);
  }

  Future<void> _addPerson(Map<String, String> newContact) async {
    final existingContacts = await DBHelper().getContacts();
    final nicknameExists = existingContacts.any((contact) => contact['nickname'] == newContact['nickname']);
    final phoneExists = existingContacts.any((contact) => contact['phone'] == newContact['phone']);

    if (nicknameExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nickname "${newContact['nickname']}" already exists. Please choose a different one.')),
      );
    } else if (phoneExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number "${newContact['phone']}" already exists. Please use a different one.')),
      );
    } else {
      await DBHelper().addContact(newContact['name']!, newContact['nickname']!, newContact['phone']!);
      _fetchContacts();
    }
  }

  void _deleteContact(int id) async {
    await DBHelper().deleteContact(id);
    _fetchContacts();
  }

  void _updateContact(Map<String, dynamic> updatedContact) async {
    await DBHelper().updateContact(updatedContact['id'], updatedContact['name'], updatedContact['nickname'], updatedContact['phone']);
    _fetchContacts();
  }

  void _filterContacts(String query) {
    List<Map<String, dynamic>> results = [];
    if (query.isEmpty) {
      results = contacts;
    } else {
      results = contacts.where((contact) {
        final name = contact['name'].toLowerCase();
        final nickname = contact['nickname'].toLowerCase();
        return name.contains(query.toLowerCase()) || nickname.contains(query.toLowerCase());
      }).toList();
    }

    setState(() {
      filteredContacts = results;
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('stayLoggedIn', false); 

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              final newContact = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPersonScreen()),
              );
              if (newContact != null) {
                _addPerson(newContact);
              }
            },
          ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name or Phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (query) => _filterContacts(query),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return ListTile(
                  title: Text(contact['name']),
                  subtitle: Text('Nickname: ${contact['nickname']} | Phone: ${contact['phone']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                         icon: Icon(Icons.update, color: Colors.orange),
                        onPressed: () async {
                          final updatedContact = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdatePersonScreen(contact: contact),
                            ),
                          );
                          if (updatedContact != null) {
                            _updateContact(updatedContact);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,color: Colors.red),
                        onPressed: () => _deleteContact(contact['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.call, color: Colors.green),
                        onPressed: () => _makeDirectCall(contact['phone']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

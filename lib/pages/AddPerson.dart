import 'package:flutter/material.dart';

class AddPersonScreen extends StatefulWidget {
  @override
  _AddPersonScreenState createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController(); 
  final TextEditingController _phoneController = TextEditingController();

  bool _isValidPhoneNumber(String phone) {
    return phone.length == 8 && int.tryParse(phone) != null;
  }
  

  void _submitData() {
    final name = _nameController.text;
    final nickname = _nicknameController.text; 
    final phone = _phoneController.text;

    if (name.isNotEmpty && nickname.isNotEmpty && phone.isNotEmpty) { 
      if (_isValidPhoneNumber(phone)) {
        Navigator.pop(context, {'name': name, 'nickname': nickname, 'phone': phone}); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid 8-digit phone number')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter name, nickname, and phone')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Person')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(labelText: 'Nickname'), 
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Add Person'),
            ),
          ],
        ),
      ),
    );
  }
}

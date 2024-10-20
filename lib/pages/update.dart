import 'package:flutter/material.dart';

class UpdatePersonScreen extends StatefulWidget {
  final Map<String, dynamic> contact;

  UpdatePersonScreen({required this.contact});

  @override
  _UpdatePersonScreenState createState() => _UpdatePersonScreenState();
}

class _UpdatePersonScreenState extends State<UpdatePersonScreen> {
  late TextEditingController _nameController;
  late TextEditingController _nicknameController; 
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact['name']);
    _nicknameController = TextEditingController(text: widget.contact['nickname']); 
    _phoneController = TextEditingController(text: widget.contact['phone']);
  }

  bool _isValidPhoneNumber(String phone) {
    return phone.length == 8 && int.tryParse(phone) != null;
  }

  void _submitData() {
    final name = _nameController.text;
    final nickname = _nicknameController.text; 
    final phone = _phoneController.text;

    if (name.isNotEmpty && nickname.isNotEmpty && phone.isNotEmpty) {
      if (phone.length > 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number cannot exceed 8 digits')),
        );
      } else if (phone.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number must be exactly 8 digits')),
        );
      } else if (_isValidPhoneNumber(phone)) {
        Navigator.pop(context, {
          'id': widget.contact['id'],
          'name': name,
          'nickname': nickname, 
          'phone': phone,
        });
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
      appBar: AppBar(title: Text('Update Person')),
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
              child: Text('Update Person'),
            ),
          ],
        ),
      ),
    );
  }
}

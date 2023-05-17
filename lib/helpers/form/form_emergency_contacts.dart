import 'package:flutter/material.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyContactsForm extends StatefulWidget {
  const EmergencyContactsForm({super.key});

  @override
  State<EmergencyContactsForm> createState() => _EmergencyContactsFormState();
}

class _EmergencyContactsFormState extends State<EmergencyContactsForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final phoneNumber = _phoneNumberController.text;

      // Save the form data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('emergency_name', name);
      prefs.setString('emergency_email', email);
      prefs.setString('emergency_phone', phoneNumber);

      // Clear form fields
      _nameController.clear();
      _emailController.clear();
      _phoneNumberController.clear();

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Contato de emergencia salvo.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email address.';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [TextInputMask(mask: '(99) 99999-9999')],
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

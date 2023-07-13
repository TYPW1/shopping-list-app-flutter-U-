// create_account_page.dart

import 'package:flutter/material.dart';
import 'package:new_app/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);

      String? errorMsg = await authProvider.createAccount(_email, _password);

      if (errorMsg != null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMsg)));
      } else {
        // No need to manually navigate to the user's space.
        // The Consumer<AuthenticationProvider> widget in main.dart will automatically update the home page.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Please enter your email' : null,
                onSaved: (value) => _email = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Please enter your password'
                    : null,
                onSaved: (value) => _password = value ?? '',
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

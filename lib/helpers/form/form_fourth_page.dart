import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart ';

class FourthFormPage extends StatelessWidget {
  const FourthFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey4 = GlobalKey<FormBuilderState>();

    return ChangeNotifierProvider<FormModel>(
      create: (_) => FormModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Formulário'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<FormModel>(
            builder: (context, formData, child) => FormBuilder(
              key: _formKey4,
              initialValue: formData.toMap(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FormBuilderTextField(
                    name: 'password',
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(40),
                    ]),
                    onChanged: (val) {
                      formData.password = val!;
                    },
                  ),
                  const SizedBox(height: 8),
                  FormBuilderTextField(
                    name: 'confirm',
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Senha',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(40),
                      (val) {
                        // Custom validator to check if password and confirm are equal
                        if (val != formData.password) {
                          return 'As senhas não correspondem';
                        }
                        return null;
                      },
                    ]),
                    onChanged: (val) {
                      formData.confirm = val!;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey4.currentState!.saveAndValidate()) {
                        formData.update(_formKey4.currentState!.value);
                      }
                    },
                    child: const Text('Criar Conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormModel with ChangeNotifier {
  String _password = '';
  String _confirm = '';

  String get password => _password;
  String get confirm => _confirm;

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set confirm(String value) {
    _confirm = value;
    notifyListeners();
  }

  void update(Map<String, dynamic> formData) {
    password = formData['password'] ?? '';
    confirm = formData['confirm'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'password': _password,
      'confirm': _confirm,
    };
  }
}

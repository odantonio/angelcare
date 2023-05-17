import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FirstFormPage extends StatelessWidget {
  const FirstFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey1 = GlobalKey<FormBuilderState>();
    final _telFormatter = TextInputMask(mask: ['(99)99999-9999']);

    final List<String> typeOptions = ['Administrador', 'Monitorado'];

    return ChangeNotifierProvider<FormModel>(
      create: (_) => FormModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Primeiro Formulário'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<FormModel>(
            builder: (context, formData, child) => FormBuilder(
              key: _formKey1,
              initialValue: formData.toMap(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FormBuilderDropdown<String>(
                    name: 'type',
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Usuário',
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    items: typeOptions
                        .map((type) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        formData.type = val;
                      }
                    },
                    valueTransformer: (val) => val.toString(),
                  ),
                  const SizedBox(height: 8),
                  FormBuilderTextField(
                      name: 'name',
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.max(50),
                      ]),
                      onChanged: (val) {
                        formData.name = val!;
                      }),
                  const SizedBox(height: 8),
                  FormBuilderTextField(
                    name: 'email',
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                      FormBuilderValidators.max(50),
                    ]),
                    onChanged: (val) {
                      formData.email = val!;
                    },
                  ),
                  FormBuilderTextField(
                    name: 'phone',
                    inputFormatters: [_telFormatter],
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.max(11)
                    ]),
                    onChanged: (val) {
                      formData.phone = val!;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey1.currentState!.saveAndValidate()) {
                        formData.update(_formKey1.currentState!.value);
                        context.go('/second');
                      }
                    },
                    child: const Text('Próximo'),
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
  String _name = '';
  String _email = '';
  String _type = '';
  String _phone = '';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get type => _type;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  set email(String value) {
    _email = value;
    notifyListeners();
  }

  set type(String value) {
    _type = value;
    notifyListeners();
  }

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  void update(Map<String, dynamic> formData) {
    name = formData['name'] ?? '';
    email = formData['email'] ?? '';
    phone = formData['phone'] ?? '';
    type = formData['type'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'type': _type,
      'name': _name,
      'email': _email,
      'phone': _phone,
    };
  }
}

import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart ';

class ThirdFormPage extends StatelessWidget {
  const ThirdFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey3 = GlobalKey<FormBuilderState>();

    final _cepFormatter = TextInputMask(mask: ['99.999-999']);

    final List<String> docOptions = ['RG', 'CPF', 'CNPJ'];
    final List<String> genderOptions = ['Feminino', 'Masculino', 'Outros'];

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
              key: _formKey3,
              initialValue: formData.toMap(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FormBuilderTextField(
                    name: 'mainAddress',
                    decoration: const InputDecoration(
                      labelText: 'Endereço',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(80),
                    ]),
                    onChanged: (val) {
                      formData.mainAddress = val!;
                    },
                  ),
                  const SizedBox(height: 8),
                  FormBuilderTextField(
                    name: 'complAddress',
                    decoration: const InputDecoration(
                      labelText: 'Complemento',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(80),
                    ]),
                    onChanged: (val) {
                      formData.complAddress = val!;
                    },
                  ),
                  const SizedBox(height: 8),
                  FormBuilderTextField(
                    name: 'country',
                    decoration: const InputDecoration(
                      labelText: 'País',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(6),
                    ]),
                    onChanged: (val) {
                      formData.country = val!;
                    },
                  ),
                  const SizedBox(height: 16),
                  FormBuilderTextField(
                    name: 'state',
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(2),
                    ]),
                    onChanged: (val) {
                      formData.state = val!;
                    },
                  ),
                  FormBuilderTextField(
                    name: 'city',
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(6),
                    ]),
                    onChanged: (val) {
                      formData.city = val!;
                    },
                  ),
                  FormBuilderTextField(
                    name: 'cep',
                    inputFormatters: [_cepFormatter],
                    decoration: const InputDecoration(
                      labelText: 'CEP',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.max(8),
                    ]),
                    onChanged: (val) {
                      formData.cep = val!;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey3.currentState!.saveAndValidate()) {
                        formData.update(_formKey3.currentState!.value);
                        Navigator.pushNamed(context, '/fourth');
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
  String _mainAddress = '';
  String _complAddress = '';
  String _country = '';
  String _state = '';
  String _city = '';
  String _cep = '';

  String get mainAddress => _mainAddress;
  String get complAddress => _complAddress;
  String get country => _country;
  String get state => _state;
  String get city => _city;
  String get cep => _cep;

  set mainAddress(String value) {
    _mainAddress = value;
    notifyListeners();
  }

  set complAddress(String value) {
    _complAddress = value;
    notifyListeners();
  }

  set country(String value) {
    _country = value;
    notifyListeners();
  }

  set state(String value) {
    _state = value;
    notifyListeners();
  }

  set city(String value) {
    _city = value;
    notifyListeners();
  }

  set cep(String value) {
    _cep = value;
    notifyListeners();
  }

  void update(Map<String, dynamic> formData) {
    mainAddress = formData['mainAddress'] ?? '';
    complAddress = formData['complAddress'] ?? '';
    country = formData['country'] ?? '';
    state = formData['state'] ?? '';
    city = formData['city'] ?? '';
    cep = formData['cep'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'mainAddress': _mainAddress,
      'complAddress': _complAddress,
      'country': _country,
      'state': _state,
      'city': _city,
      'cep': _cep,
    };
  }
}

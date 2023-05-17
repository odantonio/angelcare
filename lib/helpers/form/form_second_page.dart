import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:form_builder_validators/form_builder_validators.dart ';

class SecondFormPage extends StatelessWidget {
  const SecondFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey2 = GlobalKey<FormBuilderState>();
    final _cpfCnpjFormatter =
        TextInputMask(mask: ['999.999.999-99', '999.999.999/999-9']);
    final _rgFormatter = TextInputMask(mask: [
      '99.999.999-99',
      '9.999.999-99',
      'AA-99.999.999',
      '999.999.999'
    ]);

    String? selectedDocumentType;

    final List<String> docOptions = ['RG', 'CPF', 'CNPJ'];
    final List<String> genderOptions = ['Feminino', 'Masculino', 'Outros'];

    List<TextInputFormatter>? _getDocumentNumberFormatter() {
      switch (selectedDocumentType) {
        case 'CPF':
          return [_cpfCnpjFormatter];
        case 'CNPJ':
          return [_cpfCnpjFormatter];
        case 'RG':
          return [_rgFormatter];
        default:
          return null;
      }
    }

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
              key: _formKey2,
              initialValue: formData.toMap(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FormBuilderDropdown<String>(
                    name: 'documentType',
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Documento de Identidade',
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    items: docOptions
                        .map((docType) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: docType,
                              child: Text(docType),
                            ))
                        .toList(),
                    onChanged: (val) {
                      selectedDocumentType = val;
                      formData.docType = val!;
                    },
                  ),
                  const SizedBox(height: 8),
                  FormBuilderTextField(
                    name: 'docNumber',
                    decoration: const InputDecoration(
                      labelText: 'Número do Documento',
                      border: OutlineInputBorder(),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.min(6),
                    ]),
                    onChanged: (val) {
                      formData.docNumber = val!;
                    },
                  ),
                  const SizedBox(height: 8),
                  FormBuilderDateTimePicker(
                    name: 'birthDate',
                    initialEntryMode: DatePickerEntryMode.calendar,
                    initialValue: DateTime.now(),
                    inputType: InputType.date,
                    decoration: InputDecoration(
                      labelText: 'Data de Nascimento',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _formKey2.currentState!.fields['birthDate']
                              ?.didChange(null);
                        },
                      ),
                    ),
                    onChanged: (val) {
                      formData.birthDate = val!;
                    },
                  ),
                  const SizedBox(height: 16),
                  FormBuilderDropdown<String>(
                    name: 'gender',
                    decoration: const InputDecoration(
                      labelText: 'Gênero',
                    ),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    items: genderOptions
                        .map((gender) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (val) {
                      formData.gender = val!;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey2.currentState!.saveAndValidate()) {
                        formData.update(_formKey2.currentState!.value);
                        Navigator.pushNamed(context, '/third');
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
  String _docType = '';
  String _docNumber = '';
  DateTime _birthDate = DateTime.now();
  int _age = 0;
  String _gender = '';

  String get docType => _docType;
  String get docNumber => _docNumber;
  DateTime get birthDate => _birthDate;
  int get age => _age;
  String get gender => _gender;

  set docType(String value) {
    _docType = value;
    notifyListeners();
  }

  set docNumber(String value) {
    _docNumber = value;
    notifyListeners();
  }

  set birthDate(DateTime value) {
    _birthDate = value;
    notifyListeners();
  }

  set age(int value) {
    _age = value;
    notifyListeners();
  }

  set gender(String value) {
    _gender = value;
    notifyListeners();
  }

  void update(Map<String, dynamic> formData) {
    docType = formData['docType'] ?? '';
    docNumber = formData['docNumber'] ?? '';
    birthDate = formData['birthDate'] ?? '';
    age = formData['age'] ?? '';
    gender = formData['gender'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'docmentType': _docType,
      'documentNumber': _docNumber,
      'birthDate': _birthDate,
      'age': _age,
      'gender': _gender,
    };
  }
}

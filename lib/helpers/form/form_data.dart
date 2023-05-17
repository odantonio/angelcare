import 'package:flutter/foundation.dart';

class FormData extends ChangeNotifier {
  String? type;
  String? name;
  String? email;
  String? phoneNumber;
  String? mainAddress;
  String? complAddress;
  String? city;
  String? state;
  String? country;
  String? cep;
  String? password;
  String? confirmPassword;
  String? gender;
  String? documentType;
  String? documentNumber;
  int? age;
  DateTime? birthDate;

  void updateName(String value) {
    name = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    email = value;
    notifyListeners();
  }

  void updateType(String value) {
    type = value;
    notifyListeners();
  }

  void updatePhoneNumber(String value) {
    phoneNumber = value;
    notifyListeners();
  }

  void updateGender(String value) {
    gender = value;
    notifyListeners();
  }

  void updateDocumentType(String value) {
    documentType = value;
    notifyListeners();
  }

  void updateDocumentNumber(String value) {
    documentNumber = value;
    notifyListeners();
  }

  void updateAge(int value) {
    age = value;
    notifyListeners();
  }

  void updateBirthDate(DateTime value) {
    birthDate = value;
    notifyListeners();
  }

  void updateMainAddress(String value) {
    mainAddress = value;
    notifyListeners();
  }

  void updateComplAddress(String value) {
    complAddress = value;
    notifyListeners();
  }

  void updateCountry(String value) {
    country = value;
    notifyListeners();
  }

  void updateState(String value) {
    state = value;
    notifyListeners();
  }

  void updateCity(String value) {
    city = value;
    notifyListeners();
  }

  void updateCep(String value) {
    cep = value;
    notifyListeners();
  }
}

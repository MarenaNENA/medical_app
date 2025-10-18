import 'package:flutter/material.dart';
import 'package:flutter_mdicalapp_1/Utiles/doctor_model.dart';
import 'package:flutter_mdicalapp_1/servces/doctor_servces.dart';

class DoctorProvider with ChangeNotifier {
  final DoctorService _doctorService = DoctorService();

  List<Doctor> _doctors = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Doctor> get doctors => _doctors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDoctors() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _doctors = await _doctorService.fetchDoctors();
    } catch (e) {
      _errorMessage = 'can not loading';
    }

    _isLoading = false;
    notifyListeners();
  }
}


import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardProvider extends ChangeNotifier {
  Map<String, dynamic> _stats = {};

  Map<String, dynamic> get stats => _stats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadDashboardStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService().fetchDashboardStats();

      _stats = response;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _stats = {};
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> get _resumo {
    final resumo = _stats['resumo'];
    if (resumo is Map<String, dynamic>) return resumo;
    return {};
  }

  int _getInt(String key) {
    final value = _resumo[key];
    return (value is int) ? value : int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _getString(String key) {
    final value = _resumo[key];
    return value?.toString() ?? '0';
  }

  int get totalJogadores => _getInt('totalJogadores');
  int get otimo => _getInt('otimo');
  int get regular => _getInt('regular');
  int get baixo => _getInt('baixo');

  String get mediaVelocidade => _getString('mediaVelocidade');
  String get mediaDistancia => _getString('mediaDistancia');

  int get totalSprints => _getInt('totalSprints');

  List<dynamic> get desempenhoUltimoJogo {
    final value = _stats['desempenhoUltimoJogo'];
    return value is List ? value : [];
  }

  Map<String, dynamic> get grupos {
    final value = _stats['grupos'];
    return value is Map<String, dynamic> ? value : {};
  }
}
// lib/providers/dashboard_provider.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardProvider extends ChangeNotifier {
  Map<String, dynamic>? _stats;
  Map<String, dynamic>? get stats => _stats;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  Future<void> loadDashboardStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _stats = await ApiService().fetchDashboardStats();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  int get totalJogadores => _stats?['resumo']['totalJogadores'] ?? 0;
  int get otimo => _stats?['resumo']['otimo'] ?? 0;
  int get regular => _stats?['resumo']['regular'] ?? 0;
  int get baixo => _stats?['resumo']['baixo'] ?? 0;
  String get mediaVelocidade => _stats?['resumo']['mediaVelocidade'] ?? '0';
  String get mediaDistancia => _stats?['resumo']['mediaDistancia'] ?? '0';
  int get totalSprints => _stats?['resumo']['totalSprints'] ?? 0;
  
  List<dynamic> get desempenhoUltimoJogo => _stats?['desempenhoUltimoJogo'] ?? [];
  
  Map<String, dynamic> get grupos => _stats?['grupos'] ?? {};
}
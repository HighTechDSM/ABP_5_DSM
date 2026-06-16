// lib/providers/perfis_provider.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PerfisProvider extends ChangeNotifier {
  Map<String, dynamic>? _perfisPorPosicao;
  Map<String, dynamic>? get perfisPorPosicao => _perfisPorPosicao;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  Future<void> loadPerfis() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _perfisPorPosicao = await ApiService.getPerfisPorPosicao();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  List<String> get posicoes => _perfisPorPosicao?.keys.toList() ?? [];
  
  List<dynamic> getJogadoresByPosicao(String posicao) {
    return _perfisPorPosicao?[posicao] ?? [];
  }
  
  Future<List<dynamic>> encontrarSubstitutos(String posicao, String perfil) async {
    try {
      return await ApiService.encontrarSubstitutos(posicao, perfil);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }
  
  Future<Map<String, dynamic>?> getPerfilJogador(String athlete) async {
    try {
      return await ApiService.getPerfilJogador(athlete);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
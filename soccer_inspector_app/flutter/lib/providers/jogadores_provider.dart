// lib/providers/jogadores_provider.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class JogadoresProvider extends ChangeNotifier {
  List<dynamic> _jogadores = [];
  List<dynamic> get jogadores => _jogadores;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  Future<void> loadJogadores() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _jogadores = await ApiService.getJogadores();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Buscar por ID
  Future<Map<String, dynamic>?> getJogadorById(int id) async {
    try {
      // Primeiro tenta encontrar na lista já carregada
      if (_jogadores.isNotEmpty) {
        for (final jogador in _jogadores) {
          if (jogador['id'] == id) {
            return Map<String, dynamic>.from(jogador);
          }
        }
      }
      
      // Se não encontrar, busca na API
      final jogador = await ApiService.getJogadorById(id);
      if (jogador != null && !_jogadores.any((j) => j['id'] == id)) {
        _jogadores.add(jogador);
        notifyListeners();
      }
      return jogador;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
  
  // Buscar por nome (mantido para compatibilidade)
  Future<Map<String, dynamic>?> getJogador(String athlete) async {
    try {
      if (_jogadores.isEmpty) {
        _jogadores = await ApiService.getJogadores();
      }

      for (final jogador in _jogadores) {
        if (jogador['nome'] == athlete) {
          return Map<String, dynamic>.from(jogador);
        }
      }

      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
  
  List<dynamic> getJogadoresByGrupo(String grupo) {
    return _jogadores.where((j) => j['posicao'] == grupo).toList();
  }
  
  List<dynamic> getJogadoresByRendimento(String rendimento) {
    return _jogadores.where((j) => j['rendimento'] == rendimento).toList();
  }
  
  List<dynamic> filterJogadores(String query, String filtroRendimento) {
    return _jogadores.where((j) {
      final nome = j['nome'].toString().toLowerCase();
      final posicao = j['posicao'].toString().toLowerCase();
      final rendimento = j['rendimento'];
      
      final fOk = filtroRendimento == 'Todos' || 
          (rendimento == 'otimo' && filtroRendimento == 'Ótimo') ||
          (rendimento == 'regular' && filtroRendimento == 'Regular') ||
          (rendimento == 'baixo' && filtroRendimento == 'Baixo');
      
      final qOk = query.isEmpty ||
          nome.contains(query.toLowerCase()) ||
          posicao.contains(query.toLowerCase());
      
      return fOk && qOk;
    }).toList();
  }
}
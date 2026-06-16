// lib/services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else {
      return 'http://10.0.2.2:3000/api';
    }
  }

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<void> removeToken() async {
    await _storage.delete(key: 'auth_token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    debugPrint('Login URL: $url');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    debugPrint('Login response status: ${response.statusCode}');
    debugPrint('Login response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      return data;
    } else if (response.statusCode == 401) {
      throw Exception('E-mail ou senha inválidos');
    } else {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Falha no login. Tente novamente.');
      } catch (e) {
        throw Exception('Erro ao conectar com o servidor');
      }
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    debugPrint('Register URL: $url');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    debugPrint('Register response status: ${response.statusCode}');
    debugPrint('Register response body: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      return data;
    } else if (response.statusCode == 400) {
      try {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Usuário já existe com este e-mail');
      } catch (e) {
        throw Exception('Erro ao cadastrar usuário');
      }
    } else {
      throw Exception('Falha no cadastro');
    }
  }

  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    await removeToken();
  }

  // Buscar jogador por ID
  static Future<Map<String, dynamic>?> getJogadorById(int id) async {
    try {
      final token = await getToken();
      if (token == null) return null;
      
      final url = Uri.parse('$baseUrl/jogadores/id/$id');
      debugPrint('Fetching jogador by ID from: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      debugPrint('Jogador by ID response status: ${response.statusCode}');
      debugPrint('Jogador by ID response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Exception fetching jogador by ID: $e');
      return null;
    }
  }

  // Buscar todos os jogadores
  static Future<List<dynamic>> getJogadores() async {
    try {
      final token = await getToken();
      if (token == null) return [];
      
      final url = Uri.parse('$baseUrl/jogadores');
      debugPrint('Fetching jogadores from: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      debugPrint('Jogadores response status: ${response.statusCode}');
      debugPrint('Jogadores response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          debugPrint('Found ${data.length} jogadores');
          return data;
        }
        return [];
      } else {
        debugPrint('Error fetching jogadores: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Exception fetching jogadores: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchDashboardStats() async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl/dashboard/stats');
      
      debugPrint('Fetching dashboard stats from: $url');
      
      final response = await http.get(url, headers: headers);
      
      debugPrint('Dashboard stats response: ${response.statusCode}');
      debugPrint('Dashboard stats body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        debugPrint('Error fetching dashboard stats: ${response.statusCode}');
        return _getDefaultDashboardStats();
      }
    } catch (e) {
      debugPrint('Exception fetching dashboard stats: $e');
      return _getDefaultDashboardStats();
    }
  }
  
  Map<String, dynamic> _getDefaultDashboardStats() {
    return {
      'resumo': {
        'totalJogadores': 0,
        'otimo': 0,
        'regular': 0,
        'baixo': 0,
        'mediaVelocidade': '0',
        'mediaDistancia': '0',
        'totalSprints': 0
      },
      'grupos': {},
      'desempenhoUltimoJogo': []
    };
  }

  static Future<Map<String, dynamic>?> getPerfisPorPosicao() async {
    try {
      final token = await getToken();
      if (token == null) return null;
      
      final url = Uri.parse('$baseUrl/perfis/posicoes');
      debugPrint('Fetching perfis from: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      debugPrint('Perfis response status: ${response.statusCode}');
      debugPrint('Perfis response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint('Error fetching perfis: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      debugPrint('Exception fetching perfis: $e');
      return {};
    }
  }

static Future<List<dynamic>> getEvolucaoMediaElenco() async {
  final response = await http.get(
    Uri.parse('$baseUrl/dashboard/evolucao'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  throw Exception(
    'Erro ao carregar evolução do elenco'
  );
}

  static Future<List<dynamic>> encontrarSubstitutos(String posicao, String perfil) async {
    try {
      final token = await getToken();
      if (token == null) return [];
      
      final url = Uri.parse('$baseUrl/perfis/substitutos?posicao=${Uri.encodeComponent(posicao)}&perfil=${Uri.encodeComponent(perfil)}');
      debugPrint('Finding substitutos from: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      debugPrint('Substitutos response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) return data;
        if (data['data'] is List) return data['data'];
        return [];
      }
      return [];
    } catch (e) {
      debugPrint('Exception finding substitutos: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getPerfilJogador(String athlete) async {
    try {
      final token = await getToken();
      if (token == null) return null;
      
      final url = Uri.parse('$baseUrl/perfis/${Uri.encodeComponent(athlete)}');
      debugPrint('Getting perfil jogador from: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      debugPrint('Perfil jogador response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Exception getting perfil jogador: $e');
      return null;
    }
  }
}
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_palette.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/home_screen.dart';
import 'screens/jogadores_screen.dart';
import 'screens/analise_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/dashboard_grupo_screen.dart';
import 'screens/perfis_screen.dart';
import 'screens/inicio_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/jogadores_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/perfis_provider.dart';

// Remover o hide e usar um alias para o provider se necessário
// Ou renomear a classe na jogadores_screen.dart

void main() => runApp(const SoccerInspectorApp());

class SoccerInspectorApp extends StatelessWidget {
  const SoccerInspectorApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => JogadoresProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => PerfisProvider()),
      ],
      child: MaterialApp(
        title: 'SOCCER Inspector',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        initialRoute: '/',
        routes: {
          '/': (_) => const LandingScreen(),
          '/login': (_) => const LoginScreen(),
          '/cadastro': (_) => const CadastroScreen(),
          '/app': (_) => const RootShell(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/jogador') {
            final args = settings.arguments as Map<String, dynamic>;
            final jogadorId = args['id'] as int;
            final jogadorNome = args['nome'] as String;
            return MaterialPageRoute(
              builder: (_) => AnaliseScreen(
                jogadorId: jogadorId,
                jogadorNome: jogadorNome,
              ),
            );
          }
          if (settings.name == '/dashboard_grupo') {
            return MaterialPageRoute(
              builder: (_) => const DashboardGrupoScreen(),
            );
          }
          return null;
        },
      ),
    );
  }
}

/// Bottom-nav shell que troca entre Home, Jogadores, Dashboard e Perfis.
class RootShell extends StatefulWidget {
  const RootShell({super.key});
  
  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const JogadoresListScreen(), // Nome alterado
    const DashboardScreen(),
    const PerfisScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppPalette.pitchGradient),
        child: SafeArea(child: _pages[_index]),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: AppPalette.surface1.withOpacity(0.92),
          borderRadius: AppPalette.radiusLg,
          border: Border.all(color: AppPalette.border),
          boxShadow: AppPalette.card,
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppPalette.primary,
          unselectedItemColor: AppPalette.mutedFg,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              activeIcon: Icon(Icons.groups),
              label: 'Jogadores',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              activeIcon: Icon(Icons.account_circle),
              label: 'Perfis',
            ),
          ],
        ),
      ),
    );
  }
}
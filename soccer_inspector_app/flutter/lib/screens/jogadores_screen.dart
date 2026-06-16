// lib/screens/jogadores_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_palette.dart';
import '../widgets/common.dart';
import '../providers/jogadores_provider.dart';

class JogadoresListScreen extends StatefulWidget {
  const JogadoresListScreen({super.key});

  @override
  State<JogadoresListScreen> createState() => _JogadoresListScreenState();
}

class _JogadoresListScreenState extends State<JogadoresListScreen> {
  String _query = '';
  String _filtro = 'Todos';
  bool _isLoading = true;
  final List<String> filtros = const ['Todos', 'Ótimo', 'Regular', 'Baixo'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await context.read<JogadoresProvider>().loadJogadores();
    setState(() => _isLoading = false);
  }

  String _getRendimentoLabel(String rendimento) {
    switch (rendimento) {
      case 'otimo':
        return 'Ótimo';
      case 'regular':
        return 'Regular';
      case 'baixo':
        return 'Baixo';
      default:
        return rendimento;
    }
  }

  Color _getRendimentoColor(String rendimento) {
    switch (rendimento) {
      case 'otimo':
        return AppPalette.success;
      case 'regular':
        return AppPalette.warning;
      case 'baixo':
        return AppPalette.danger;
      default:
        return AppPalette.mutedFg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final horizontalPadding = isMobile ? 20.0 : (isTablet ? 40.0 : 60.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppPalette.pitchGradient),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: RefreshIndicator(
                onRefresh: _loadData,
                child: Consumer<JogadoresProvider>(
                  builder: (context, provider, child) {
                    if (_isLoading || (provider.isLoading && provider.jogadores.isEmpty)) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final visiveis = provider.filterJogadores(_query, _filtro);

                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                          horizontalPadding, 16, horizontalPadding, 24),
                      children: [
                        const Text('Jogadores',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800)),
                        const Text('Selecione um atleta para análise.',
                            style: TextStyle(color: AppPalette.mutedFg)),
                        const SizedBox(height: 16),
                        TextField(
                          onChanged: (v) => setState(() => _query = v),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search, size: 18),
                            hintText: 'Buscar por nome ou posição',
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 32,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: filtros.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 6),
                            itemBuilder: (_, i) {
                              final f = filtros[i];
                              final active = _filtro == f;
                              return GestureDetector(
                                onTap: () => setState(() => _filtro = f),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: active
                                        ? AppPalette.primaryGradient
                                        : null,
                                    color: active ? null : AppPalette.surface2,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(f,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: active
                                            ? const Color(0xFF0A1410)
                                            : AppPalette.mutedFg,
                                      )),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...visiveis.map((j) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                borderRadius: AppPalette.radiusLg,
                                onTap: () => Navigator.pushNamed(
                                  context, 
                                  '/jogador', 
                                  arguments: {
                                    'id': j['id'],
                                    'nome': j['nome']
                                  }
                                ),
                                child: GlassCard(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  child: Row(children: [
                                    JerseyAvatar(numero: j['numero'] ?? 0),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Removido o # e o número, deixando apenas o nome
                                            Text(j['nome'] ?? '',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    fontSize: 15)),
                                            Text(
                                                '${j['posicao'] ?? ''} · ${j['perfil'] ?? 'Regular'}',
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color:
                                                        AppPalette.mutedFg)),
                                            const SizedBox(height: 4),
                                            Text(
                                                '${j['velocidadeMax'] ?? 0} km/h · ${j['distancia'] ?? 0} km',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color:
                                                        AppPalette.mutedFg)),
                                          ]),
                                    ),
                                    StatusPill(
                                      label: _getRendimentoLabel(
                                          j['rendimento'] ?? 'regular'),
                                      color: _getRendimentoColor(
                                          j['rendimento'] ?? 'regular'),
                                    ),
                                  ]),
                                ),
                              ),
                            )),
                        if (visiveis.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                                child: Text('Nenhum jogador encontrado.',
                                    style: TextStyle(
                                        color: AppPalette.mutedFg))),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
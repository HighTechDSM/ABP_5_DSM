// lib/screens/perfis_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_palette.dart';
import '../widgets/common.dart';
import '../providers/perfis_provider.dart';

class PerfisScreen extends StatefulWidget {
  const PerfisScreen({super.key});

  @override
  State<PerfisScreen> createState() => _PerfisScreenState();
}

class _PerfisScreenState extends State<PerfisScreen> {
  String _filtro = 'Todos';
  bool _isLoading = true;
  final List<String> perfis = const [
    'Todos',
    'Explosivo',
    'Alta resistência',
    'Baixa intensidade',
    'Alta carga de impacto',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await context.read<PerfisProvider>().loadPerfis();
    setState(() => _isLoading = false);
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
                child: Consumer<PerfisProvider>(
                  builder: (context, provider, child) {
                    if (_isLoading || (provider.isLoading && provider.perfisPorPosicao == null)) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final perfisMap = provider.perfisPorPosicao ?? {};
                    List<MapEntry<String, dynamic>> grupos = [];

                    if (_filtro == 'Todos') {
                      grupos = perfisMap.entries.toList();
                    } else {
                      final jogadoresFiltrados = <String, List<dynamic>>{};
                      for (var entry in perfisMap.entries) {
                        final jogadoresFiltradosPorPerfil =
                            (entry.value as List).where((j) {
                          final perfilJogador = j['perfil'] ?? 'Regular';
                          return perfilJogador == _filtro;
                        }).toList();
                        if (jogadoresFiltradosPorPerfil.isNotEmpty) {
                          jogadoresFiltrados[entry.key] =
                              jogadoresFiltradosPorPerfil;
                        }
                      }
                      grupos = jogadoresFiltrados.entries.toList();
                    }

                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                          horizontalPadding, 16, horizontalPadding, 24),
                      children: [
                        const Text(
                          'Perfis de jogadores',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Encontre substitutos compatíveis por posição e perfil.',
                          style: TextStyle(color: AppPalette.mutedFg),
                        ),
                        const SizedBox(height: 12),
                        GlassCard(
                          borderColor: AppPalette.accent.withOpacity(0.4),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: AppPalette.accent,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'O perfil ajuda a encontrar o melhor substituto da mesma posição. '
                                  'A prioridade é compatibilidade de perfil, depois métricas físicas.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppPalette.mutedFg,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: perfis.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 6),
                            itemBuilder: (_, i) {
                              final p = perfis[i];
                              final active = _filtro == p;
                              return GestureDetector(
                                onTap: () => setState(() => _filtro = p),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: active
                                        ? AppPalette.primaryGradient
                                        : null,
                                    color: active ? null : AppPalette.surface2,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    p,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: active
                                          ? const Color(0xFF0A1410)
                                          : AppPalette.mutedFg,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...grupos.map((entry) {
                          final posicao = entry.key;
                          final jogadoresLista = entry.value as List;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      posicao.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppPalette.mutedFg,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    if (jogadoresLista.length > 1)
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.swap_horiz,
                                            size: 12,
                                            color: AppPalette.accent,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${jogadoresLista.length} compatíveis',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: AppPalette.accent,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ...jogadoresLista.map((j) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: InkWell(
                                        borderRadius: AppPalette.radiusLg,
                                        onTap: () {
                                          // Verificar se o ID existe
                                          final jogadorId = j['id'];
                                          final jogadorNome = j['nome'];
                                          
                                          print('Navegando para análise do jogador: ID=$jogadorId, Nome=$jogadorNome');
                                          
                                          if (jogadorId != null) {
                                            Navigator.pushNamed(
                                              context, 
                                              '/jogador', 
                                              arguments: {
                                                'id': jogadorId,
                                                'nome': jogadorNome
                                              }
                                            );
                                          } else {
                                            // Fallback para navegar por nome se ID não existir
                                            Navigator.pushNamed(
                                              context, 
                                              '/jogador', 
                                              arguments: {
                                                'id': j['numero'] ?? 0,
                                                'nome': jogadorNome
                                              }
                                            );
                                          }
                                        },
                                        child: GlassCard(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 12),
                                          child: Row(
                                            children: [
                                              JerseyAvatar(
                                                  numero: j['numero'] ?? 0,
                                                  size: isMobile ? 36 : 40),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      j['nome'] ?? '',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Text(
                                                      j['perfil'] ?? 'Regular',
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color:
                                                            AppPalette.mutedFg,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '${j['velocidadeMax'] ?? 0}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: AppPalette.primary,
                                                    ),
                                                  ),
                                                  const Text(
                                                    'km/h',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      color: AppPalette.mutedFg,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          );
                        }),
                        if (grupos.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Text(
                                'Nenhum jogador encontrado para este perfil.',
                                style: TextStyle(color: AppPalette.mutedFg),
                              ),
                            ),
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
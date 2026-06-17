// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_palette.dart';
import '../widgets/common.dart';
import '../providers/dashboard_provider.dart';
import '../providers/jogadores_provider.dart';
import '../services/api_service.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;

  List<dynamic> evolucao = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });

    carregarEvolucao();
  }

  Future<void> carregarEvolucao() async {
    try {
      evolucao = await ApiService.getEvolucaoMediaElenco();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Erro ao carregar evolução: $e');
    }
  }

  Future<void> _loadData() async {
  if (!mounted) return;

  setState(() => _isLoading = true);

  final jogadoresProvider = context.read<JogadoresProvider>();
  final dashboardProvider = context.read<DashboardProvider>();

  await jogadoresProvider.loadJogadores();
  await dashboardProvider.loadDashboardStats();

  if (!mounted) return;

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
                child: Consumer2<DashboardProvider, JogadoresProvider>(
                  builder: (context, dashboard, jogadores, child) {
                   if (_isLoading || dashboard.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final total = dashboard.totalJogadores;
                    final otimo = dashboard.otimo;
                    final regular = dashboard.regular;
                    final baixo = dashboard.baixo;
                    final desempenhoUltimoJogo = dashboard.desempenhoUltimoJogo;
                    final crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);
                    final chartHeight = isMobile ? 220.0 : 280.0;

                    if (jogadores.jogadores.isNotEmpty) {
                    debugPrint(jogadores.jogadores.first.toString());
                    }

                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                          horizontalPadding, 16, horizontalPadding, 24),
                      children: [
                        const Text('Dashboard geral',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800)),
                        const Text('Visão consolidada do elenco.',
                            style: TextStyle(color: AppPalette.mutedFg)),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.6,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _kpi(Icons.groups, 'Atletas', total,
                                AppPalette.accent),
                            _kpi(Icons.emoji_events, 'Em ótima forma', otimo,
                                AppPalette.success),
                            _kpi(Icons.bolt, 'Regulares', regular,
                                AppPalette.warning),
                            _kpi(Icons.warning_amber_rounded, 'Em alerta',
                                baixo, AppPalette.danger),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const _Section('DISTRIBUIÇÃO DE RENDIMENTO'),
                        GlassCard(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(spacing: 6, children: [
                                  _pill('Ótimo · $otimo', AppPalette.success),
                                  _pill('Regular · $regular',
                                      AppPalette.warning),
                                  _pill('Baixo · $baixo', AppPalette.danger),
                                ]),
                                const SizedBox(height: 20),
                                if (total > 0)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      height: 32,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: otimo,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    AppPalette.success,
                                                    AppPalette.success
                                                        .withValues(alpha: 0.8),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: regular,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    AppPalette.warning,
                                                    AppPalette.warning
                                                        .withValues(alpha: 0.8),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: baixo,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    AppPalette.danger,
                                                    AppPalette.danger
                                                        .withValues(alpha: 0.8),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _legenda('Ótimo', AppPalette.success,
                                        otimo),
                                    const SizedBox(width: 16),
                                    _legenda('Regular', AppPalette.warning,
                                        regular),
                                    const SizedBox(width: 16),
                                    _legenda('Baixo', AppPalette.danger, baixo),
                                  ],
                                ),
                              ]),
                        ),
                        const SizedBox(height: 24),

                        const _Section('EVOLUÇÃO MÉDIA DO ELENCO'),
                        GlassCard(
                          child: desempenhoUltimoJogo.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Center(
                                      child: Text('Sem dados disponíveis')),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12, top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            '',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 0),
                                            decoration: BoxDecoration(
                                              color: AppPalette.primary
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.trending_up,
                                                    size: 12,
                                                    color: AppPalette.primary),
                                                SizedBox(width: 4),
                                                Text(
                                                  'Alta performance',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppPalette.primary),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    _evolucaoMediaElenco(jogadores),

                                    const SizedBox(height: 16),
                                    const _Section('RENDIMENTO POR ATLETA (ÚLTIMO JOGO)'),

                                    const Divider(
                                        color: AppPalette.border, height: 16),
                                    SizedBox(
                                      height: chartHeight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 16,
                                            left: 12,
                                            right: 12),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: desempenhoUltimoJogo
                                              .map((j) {
                                            final v = j['valor'] ?? 0;
                                            final maxV = desempenhoUltimoJogo
                                                    .map((x) => x['valor'] ?? 0)
                                                    .reduce((a, b) =>
                                                        a > b ? a : b) ??
                                                1;
                                            final porcentagem = v / maxV;
                                            return Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        isMobile ? 3 : 6),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 6,
                                                              vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: AppPalette.primary
                                                            .withValues(alpha: 0.15),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Text(
                                                        '${v.toStringAsFixed(1)}',
                                                        style: TextStyle(
                                                          fontSize:
                                                              isMobile ? 9 : 10,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: AppPalette
                                                              .primary,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Expanded(
                                                      child: LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          return Stack(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppPalette
                                                                      .surface2,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                              ),
                                                              AnimatedContainer(
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        800),
                                                                curve: Curves
                                                                    .easeOutCubic,
                                                                width: double
                                                                    .infinity,
                                                                height: constraints
                                                                        .maxHeight *
                                                                    porcentagem,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    begin: Alignment
                                                                        .bottomCenter,
                                                                    end: Alignment
                                                                        .topCenter,
                                                                    colors: [
                                                                      AppPalette
                                                                          .primary,
                                                                      AppPalette
                                                                          .primary
                                                                          .withValues(
                                                                              alpha: 0.7),
                                                                      AppPalette
                                                                          .accent
                                                                          .withValues(
                                                                              alpha: 0.5),
                                                                    ],
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: AppPalette
                                                                          .primary
                                                                          .withValues(
                                                                              alpha: 0.3),
                                                                      blurRadius:
                                                                          8,
                                                                      spreadRadius:
                                                                          0,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 4,
                                                              vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: AppPalette
                                                            .surface2,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                      child: Text(
                                                        j['nome']
                                                                ?.split(' ')
                                                                .first ??
                                                            '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize:
                                                              isMobile ? 10 : 11,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppPalette
                                                              .mutedFg,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
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


Widget _evolucaoMediaElenco(JogadoresProvider jogadoresProvider) {
  final jogadores = jogadoresProvider.jogadores;

  final Map<String, List<double>> mediasPorData = {};

  for (final jogador in jogadores) {
    final historico = jogador['historico'] ?? [];

    for (final item in historico) {
      final data = item['data'] ?? '';
      final valor = (item['valor'] as num?)?.toDouble() ?? 0;

      mediasPorData.putIfAbsent(data, () => []);
      mediasPorData[data]!.add(valor);
    }
  }

  final dados = mediasPorData.entries.map((e) {
    final media =
        e.value.reduce((a, b) => a + b) / e.value.length;

    return {
      'data': e.key,
      'media': media,
    };
  }).toList();

  dados.sort(
    (a, b) => (a['data'] as String)
        .compareTo(b['data'] as String),
  );

  return GlassCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          height: 320,
          child: RadarChart(
            RadarChartData(
              radarShape: RadarShape.polygon,
              tickCount: 4,

              ticksTextStyle: const TextStyle(
                color: AppPalette.mutedFg,
                fontSize: 10,
              ),

              gridBorderData: BorderSide(
                color: Colors.green.withValues(alpha: .25),
              ),

              radarBorderData: BorderSide(
                color: Colors.green.withValues(alpha: .30),
              ),

              titleTextStyle: const TextStyle(
                color: AppPalette.mutedFg,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),

              getTitle: (index, angle) {
                return RadarChartTitle(
                  text: dados[index]['data'].toString(),
                );
              },

              dataSets: [
                RadarDataSet(
                  fillColor:
                      Colors.greenAccent.withValues(alpha: .25),

                  borderColor:
                      Colors.greenAccent,

                  borderWidth: 2,
                  entryRadius: 3,

                  dataEntries: dados.map((item) {
                    return RadarEntry(
                      value:
                          (item['media'] as num).toDouble(),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _kpi(IconData icon, String label, int value, Color c) => GlassCard(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.18),
                  borderRadius: AppPalette.radiusSm),
              child: Icon(icon, size: 16, color: c),
            ),
            Text('$value',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: c)),
          ]),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppPalette.mutedFg)),
        ]),
      );

  Widget _pill(String label, Color c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: c.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.withValues(alpha: 0.3))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  color: c, fontSize: 11, fontWeight: FontWeight.w700)),
        ]),
      );

  Widget _legenda(String label, Color color, int quantidade) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 6),
          Text(
            '$label ($quantidade)',
            style: const TextStyle(fontSize: 11, color: AppPalette.mutedFg),
          ),
        ],
      );
}

class _Section extends StatelessWidget {
  final String text;
  const _Section(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(text,
            style: const TextStyle(
                fontSize: 12,
                color: AppPalette.mutedFg,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800)),
      );
}
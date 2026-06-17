// lib/screens/analise_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soccer_inspector/services/ai_service.dart';
import '../theme/app_palette.dart';
import '../widgets/common.dart';
import '../providers/jogadores_provider.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:fl_chart/fl_chart.dart';

class AnaliseScreen extends StatefulWidget {
  final int jogadorId;
  final String jogadorNome;

  const AnaliseScreen({
    super.key,
    required this.jogadorId,
    required this.jogadorNome,
  });

  @override
  State<AnaliseScreen> createState() => _AnaliseScreenState();
}

class _AnaliseScreenState extends State<AnaliseScreen> {
  Map<String, dynamic>? _jogador;
  bool _isLoading = true;
  String? _error;

  final ScrollController _chartController = ScrollController();

  // ==========================================
  // CHAMAR IA
  // ==========================================
  Future<void> _gerarAnaliseIA() async {
    print("BOTÃO CLICADO");

    if (_jogador == null) {
      print("_jogador está null");
      return;
    }

    try {
      final resultado = await AIService.gerarRelatorio(
        athleteId: widget.jogadorId,
        distance: (_jogador!['distancia'] ?? 0).toDouble(),
        metresPerMinute: (_jogador!['metresPerMinute'] ?? 0).toDouble(),
        duration: (_jogador!['minutesPlayed'] ?? 90).toDouble(),
        highIntensityRunning:
            (_jogador!['highIntensityRunning'] ?? 0).toDouble(),
        highIntensityEvents: (_jogador!['highIntensityEvents'] ?? 0).toDouble(),
        sprintDistance: (_jogador!['sprintDistance'] ?? 0).toDouble(),
        sprints: (_jogador!['sprints'] ?? 0).toDouble(),
        rawTopSpeed: (_jogador!['rawTopSpeed'] ?? 0).toDouble(),
        topSpeed: (_jogador!['velocidadeMax'] ?? 0).toDouble(),
        avgSpeed: (_jogador!['velocidadeMedia'] ?? 0).toDouble(),
        accelerations: (_jogador!['accelerations'] ?? 0).toDouble(),
        decelerations: (_jogador!['decelerations'] ?? 0).toDouble(),
        workload: (_jogador!['workload'] ?? 0).toDouble(),
        workloadVolume: (_jogador!['workloadVolume'] ?? 0).toDouble(),
        workloadIntensity: (_jogador!['workloadIntensity'] ?? 0).toDouble(),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Análise da IA'),
          content: Text(
            '''
Classificação: ${resultado['prediction']}

Cluster: ${resultado['cluster']}

Anomalia: ${resultado['anomaly'] == 1 ? 'Sim' : 'Não'}

Análise:

${resultado['analysis']}
''',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao consultar IA: $e',
          ),
        ),
      );
    }
  }

  Future<void> _baixarRelatorio() async {
    if (_jogador == null) return;

    final pdf = pw.Document();

    final historico =
        List<Map<String, dynamic>>.from(_jogador!['historico'] ?? []);

    final velocidades = historico
        .map((e) => (e['velocidade'] as num?)?.toDouble() ?? 0)
        .where((v) => v > 0)
        .toList();

    final mediaVelocidade = velocidades.isEmpty
        ? 0
        : velocidades.reduce((a, b) => a + b) / velocidades.length;

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Relatório do Atleta',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text('ID: ${_jogador!['numero']}'),
          pw.Text('Nome: ${_jogador!['nome']}'),
          pw.Text('Posição: ${_jogador!['posicao']}'),
          pw.Text('Perfil: ${_jogador!['perfil']}'),
          pw.Text('Rendimento: ${_jogador!['rendimento']}'),
          pw.Text('Tendência: ${_jogador!['tendencia']}%'),
          pw.SizedBox(height: 20),
          pw.Text(
            'Indicadores atuais',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text('Velocidade máxima: ${_jogador!['velocidadeMax']} km/h'),
          pw.Text('Distância: ${_jogador!['distancia']} m'),
          pw.Text('Sprints: ${_jogador!['sprints']}'),
          pw.SizedBox(height: 20),
          pw.Text(
            'Média histórica de velocidade',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            '${mediaVelocidade.toStringAsFixed(2)} km/h',
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Histórico',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.TableHelper.fromTextArray(
            headers: ['Data', 'Velocidade', 'Distância', 'Workload'],
            data: historico.map((h) {
              return [
                '${h['data']}',
                '${h['velocidade']}',
                '${h['distancia']}',
                '${h['valor']}',
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final Uint8List bytes = await pdf.save();

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'relatorio_${_jogador!['numero']}.pdf',
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final jogadoresProvider = context.read<JogadoresProvider>();
      final jogador = await jogadoresProvider.getJogadorById(widget.jogadorId);
      setState(() {
        _jogador = jogador;
        _isLoading = false;
      });

      if (jogador == null) {
        setState(() {
          _error = 'Jogador não encontrado';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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

  String _getMensagemIA(String rendimento) {
    switch (rendimento) {
      case 'otimo':
        return 'De acordo com os jogos anteriores, o jogador está indo bem atualmente! Manter a rotina de treino, condicionamento físico e boa alimentação.';
      case 'regular':
        return 'O rendimento está estável nos últimos jogos. Verifique aspectos que podem melhorar: condicionamento físico, indícios de baixa de saúde e diálogo com o técnico.';
      case 'baixo':
        return 'O rendimento diminuiu mais vezes entre os últimos jogos. Verificar situação atual de saúde do jogador (mental e física) ou rever o método de treino.';
      default:
        return 'Análise não disponível para este jogador.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final horizontalPadding = isMobile ? 20.0 : (isTablet ? 40.0 : 60.0);

    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppPalette.pitchGradient),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_error != null || _jogador == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppPalette.pitchGradient),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AppPalette.danger),
                const SizedBox(height: 16),
                Text(_error ?? 'Erro ao carregar jogador'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final j = _jogador!;

    final rendimento = j['rendimento'] ?? 'regular';
    final cor = _getRendimentoColor(rendimento);

    List<Map<String, dynamic>> historico = [];
    if (j['historico'] != null && j['historico'] is List) {
      historico = List<Map<String, dynamic>>.from(j['historico']);
    }

    final ultimo = historico.isNotEmpty ? historico.last : null;

    double maxValor = 1;
    if (historico.isNotEmpty) {
      final valores = historico
          .map((h) {
            final valor = h['valor'];
            if (valor is num) {
              return valor.toDouble();
            }
            return 0.0;
          })
          .where((v) => v > 0)
          .toList();

      if (valores.isNotEmpty) {
        maxValor = valores.reduce((a, b) => a > b ? a : b);
        if (maxValor <= 0) maxValor = 1;
      }
    }

    final chartHeight = isMobile ? 260.0 : 320.0;

    final velocidadeMax = j['velocidadeMax'] ?? 0;
    final distancia = j['distancia'] ?? 0;
    final sprints = j['sprints'] ?? 0;
    final tendencia = j['tendencia'] ?? 0;

// =====================
// DADOS PARA O RADAR
// =====================

    final mediaVelocidade = historico.isEmpty
        ? 0.0
        : historico
                .map((e) => (e['velocidade'] as num?)?.toDouble() ?? 0)
                .reduce((a, b) => a + b) /
            historico.length;

    final workload = historico.isNotEmpty
        ? ((historico.last['valor'] ?? 0) as num).toDouble()
        : 0.0;

    final velMaxNormalizado =
        (velocidadeMax.toDouble() / 40 * 100).clamp(0.0, 100.0);

    final velMediaNormalizada = (mediaVelocidade / 40 * 100).clamp(0.0, 100.0);

    final distanciaNormalizada =
        (distancia.toDouble() / 12000 * 100).clamp(0.0, 100.0);

    final sprintsNormalizado =
        (sprints.toDouble() / 30 * 100).clamp(0.0, 100.0);

    final workloadNormalizado = workload.clamp(0.0, 100.0);

    final aceleracoesNormalizado =
        (((j['accelerations'] ?? 0) as num).toDouble() / 50 * 100)
            .clamp(0.0, 100.0);

    final desaceleracoesNormalizado =
        (((j['decelerations'] ?? 0) as num).toDouble() / 50 * 100)
            .clamp(0.0, 100.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppPalette.pitchGradient),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 8, horizontalPadding, 24),
                children: [
                  Row(children: [
                    _IconBtn(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context)),
                    const Spacer(),
                    const Text('ANÁLISE',
                        style: TextStyle(
                            letterSpacing: 2,
                            color: AppPalette.mutedFg,
                            fontSize: 11,
                            fontWeight: FontWeight.w800)),
                    const Spacer(),
                    _IconBtn(
                      icon: Icons.download_outlined,
                      onTap: _baixarRelatorio,
                    ),
                  ]),
                  const SizedBox(height: 12),
                  GlassCard(
                    child: Column(children: [
                      Row(children: [
                        JerseyAvatar(numero: j['numero'] ?? 0),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  j['nome']?.toString() ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  j['posicao']?.toString() ?? '',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppPalette.mutedFg,
                                  ),
                                ),
                              ]),
                        ),
                        StatusPill(
                            label: _getRendimentoLabel(rendimento), color: cor),
                      ]),
                      const SizedBox(height: 14),
                      Row(children: [
                        Expanded(
                            child: _mini('Vel. máx', velocidadeMax.toString(),
                                'km/h', isMobile)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _mini('Distância', distancia.toString(),
                                'km', isMobile)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _mini(
                                'Sprints', sprints.toString(), '', isMobile)),
                      ]),
                      if (ultimo != null) ...[
                        const SizedBox(height: 12),
                        Row(children: [
                          const Icon(Icons.calendar_month_outlined,
                              size: 14, color: AppPalette.mutedFg),
                          const SizedBox(width: 6),
                          Text('Último jogo ${ultimo['data']}: ',
                              style: const TextStyle(
                                  fontSize: 12, color: AppPalette.mutedFg)),
                          Text(_getRendimentoLabel(rendimento),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: cor,
                                  fontWeight: FontWeight.w800)),
                          const Spacer(),
                          Icon(
                              tendencia >= 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              size: 14,
                              color: tendencia >= 0
                                  ? AppPalette.success
                                  : AppPalette.danger),
                          const SizedBox(width: 2),
                          Text('${tendencia >= 0 ? '+' : ''}$tendencia%',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: tendencia >= 0
                                      ? AppPalette.success
                                      : AppPalette.danger)),
                        ]),
                      ],
                    ]),
                  ),
                  if (rendimento == 'baixo') ...[
                    GlassCard(
                      borderColor: AppPalette.danger.withValues(alpha: 0.4),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: AppPalette.danger,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Motivo do baixo desempenho',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'O atleta apresentou queda de rendimento nos últimos jogos. '
                            'Os indicadores sugerem redução de intensidade, menor participação '
                            'nas ações de alta velocidade e possível necessidade de revisão da '
                            'carga de treinamento.',
                            style: TextStyle(
                              color: AppPalette.mutedFg,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 16),
                  const _Section('GRÁFICO DE DESEMPENHO'),
                  GlassCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final itemWidth = isMobile ? 55.0 : 70.0;
                                final fontSize = isMobile ? 8.0 : 10.0;

                                final totalWidth = historico.length <= 8
                                    ? constraints.maxWidth
                                    : historico.length * itemWidth;

                                return SizedBox(
                                  height: chartHeight,
                                  child: Scrollbar(
                                    controller: _chartController,
                                    thumbVisibility:
                                        totalWidth > constraints.maxWidth,
                                    interactive: true,
                                    thickness: 4,
                                    radius: const Radius.circular(20),
                                    child: SingleChildScrollView(
                                      controller: _chartController,
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      child: SizedBox(
                                        width: totalWidth,
                                        height: chartHeight,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment: historico.length <=
                                                  8
                                              ? MainAxisAlignment.spaceEvenly
                                              : MainAxisAlignment.start,
                                          children: historico.isEmpty
                                              ? []
                                              : historico.map((hist) {
                                                  final valor = hist['valor']
                                                          is num
                                                      ? (hist['valor'] as num)
                                                          .toDouble()
                                                      : 0.0;

                                                  final porcentagem =
                                                      maxValor > 0
                                                          ? valor / maxValor
                                                          : 0.0;

                                                  final safe = porcentagem
                                                      .clamp(0.05, 1.0);

                                                  return SizedBox(
                                                    width: itemWidth,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 4,
                                                            vertical: 2,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppPalette
                                                                .primary
                                                                .withValues(
                                                                    alpha:
                                                                        0.15),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child: Text(
                                                            '${valor.toInt()}',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  fontSize,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: AppPalette
                                                                  .primary,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Container(
                                                          width:
                                                              itemWidth * 0.5,
                                                          height: (chartHeight -
                                                                  60) *
                                                              safe,
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
                                                                        alpha:
                                                                            0.7),
                                                                AppPalette
                                                                    .accent
                                                                    .withValues(
                                                                        alpha:
                                                                            0.5),
                                                              ],
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 6),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 12),
                                                          child: Text(
                                                            hist['data'] ?? '',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  fontSize,
                                                              color: AppPalette
                                                                  .mutedFg,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          ...historico.reversed.map((h) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: const BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: AppPalette.border))),
                                child: Row(children: [
                                  Expanded(
                                      child: Row(children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: _getRendimentoColor(rendimento),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(h['data'] ?? '',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700)),
                                  ])),
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppPalette.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${h['velocidade'] ?? 0} km/h',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: AppPalette.primary,
                                      ),
                                    ),
                                  )),
                                  Expanded(
                                      child: Text('${h['distancia'] ?? 0} km',
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: AppPalette.mutedFg,
                                              fontWeight: FontWeight.w600))),
                                ]),
                              )),
                        ]),
                  ),
                  const SizedBox(height: 16),
                  const _Section('COMPARATIVO DE ATRIBUTOS'),
                  GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Comparativo de Atributos',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppPalette.primary
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Radar',
                                  style: TextStyle(
                                    color: AppPalette.primary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 350,
                            child: RadarChart(
                              RadarChartData(
                                radarShape: RadarShape.polygon,
                                tickCount: 5,
                                ticksTextStyle: const TextStyle(
                                  color: AppPalette.mutedFg,
                                  fontSize: 10,
                                ),
                                tickBorderData: BorderSide(
                                  color:
                                      AppPalette.primary.withValues(alpha: .25),
                                ),
                                gridBorderData: BorderSide(
                                  color:
                                      AppPalette.primary.withValues(alpha: .25),
                                ),
                                radarBorderData: BorderSide(
                                  color:
                                      AppPalette.primary.withValues(alpha: .30),
                                ),
                                titleTextStyle: const TextStyle(
                                  color: AppPalette.mutedFg,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                getTitle: (index, angle) {
                                  const labels = [
                                    'Vel Máx',
                                    'Vel Média',
                                    'Distância',
                                    'Sprints',
                                    'Workload',
                                    'Acel.',
                                    'Desac.',
                                  ];

                                  return RadarChartTitle(
                                    text: labels[index],
                                  );
                                },
                                dataSets: [
                                  RadarDataSet(
                                    fillColor: AppPalette.primary
                                        .withValues(alpha: .25),
                                    borderColor: AppPalette.primary,
                                    borderWidth: 2,
                                    entryRadius: 3,
                                    dataEntries: [
                                      RadarEntry(value: velMaxNormalizado),
                                      RadarEntry(value: velMediaNormalizada),
                                      RadarEntry(value: distanciaNormalizada),
                                      RadarEntry(value: sprintsNormalizado),
                                      RadarEntry(value: workloadNormalizado),
                                      RadarEntry(value: aceleracoesNormalizado),
                                      RadarEntry(
                                          value: desaceleracoesNormalizado),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _Section('INDICADORES'),
                  Row(children: [
                    Expanded(child: _ind('Ótimo', AppPalette.success)),
                    const SizedBox(width: 8),
                    Expanded(child: _ind('Regular', AppPalette.warning)),
                    const SizedBox(width: 8),
                    Expanded(child: _ind('Baixo', AppPalette.danger)),
                  ]),
                  const SizedBox(height: 16),
                  GlassCard(
                    borderColor: AppPalette.primary.withValues(alpha: 0.4),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: AppPalette.primaryGradient,
                                  borderRadius: AppPalette.radiusSm),
                              child: const Icon(Icons.auto_awesome,
                                  size: 16, color: Color(0xFF0A1410)),
                            ),
                            const SizedBox(width: 8),
                            const Text('Relatório de desempenho · IA',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 14)),
                          ]),
                          const SizedBox(height: 10),
                          Text(_getMensagemIA(rendimento),
                              style: const TextStyle(
                                  color: AppPalette.mutedFg,
                                  height: 1.5,
                                  fontSize: 13)),
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: isMobile ? 140 : 160,
                              height: isMobile ? 36 : 40,
                              child: PrimaryButton(
                                label: 'Gerar análise',
                                onPressed: _gerarAnaliseIA,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  Widget _mini(String label, String value, String unit, bool isMobile) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            color: AppPalette.surface2, borderRadius: AppPalette.radiusMd),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: value,
                style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w800,
                    color: AppPalette.foreground)),
            if (unit.isNotEmpty)
              TextSpan(
                  text: ' $unit',
                  style:
                      const TextStyle(fontSize: 10, color: AppPalette.mutedFg)),
          ])),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 10, color: AppPalette.mutedFg)),
        ]),
      );

  Widget _ind(String label, Color color) => GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(children: [
          Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 8),
          Text(label,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
      );
}

class _Section extends StatelessWidget {
  final String text;
  const _Section(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: const TextStyle(
                fontSize: 11,
                color: AppPalette.mutedFg,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800)),
      );
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: AppPalette.radiusMd,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppPalette.surface1,
            borderRadius: AppPalette.radiusMd,
            border: Border.all(color: AppPalette.border),
          ),
          child: Icon(icon, size: 18),
        ),
      );
}

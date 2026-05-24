// lib/screens/analise_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_palette.dart';
import '../widgets/common.dart';
import '../providers/jogadores_provider.dart';

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
    
    final chartHeight = isMobile ? 200.0 : 240.0;

    final nome = j['nome'] ?? 'Desconhecido';
    final posicao = j['posicao'] ?? '';
    final velocidadeMax = j['velocidadeMax'] ?? 0;
    final distancia = j['distancia'] ?? 0;
    final sprints = j['sprints'] ?? 0;
    final tendencia = j['tendencia'] ?? 0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppPalette.pitchGradient),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: ListView(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 24),
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
                    _IconBtn(icon: Icons.download_outlined, onTap: () {}),
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
                                Text(nome,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18)),
                                Text(posicao,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppPalette.mutedFg)),
                              ]),
                        ),
                        StatusPill(
                            label: _getRendimentoLabel(rendimento), color: cor),
                      ]),
                      const SizedBox(height: 14),
                      Row(children: [
                        Expanded(
                            child: _mini('Vel. máx',
                                velocidadeMax.toString(), 'km/h', isMobile)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _mini('Distância',
                                distancia.toString(), 'km', isMobile)),
                        const SizedBox(width: 8),
                        Expanded(
                            child: _mini('Sprints', sprints.toString(), '',
                                isMobile)),
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
                          Text(
                              '${tendencia >= 0 ? '+' : ''}$tendencia%',
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
                  const SizedBox(height: 16),
                  const _Section('GRÁFICO DE DESEMPENHO'),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Evolução',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppPalette.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Últimos ${historico.length} jogos',
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppPalette.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: AppPalette.border, height: 0),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            height: chartHeight,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: historico.asMap().entries.map((entry) {
                                final hist = entry.value;
                                final valor = hist['valor'] is num ? (hist['valor'] as num).toDouble() : 0.0;
                                final porcentagem = maxValor > 0 ? valor / maxValor : 0.0;
                                final safePorcentagem = porcentagem.clamp(0.05, 1.0);
                                
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 4 : 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppPalette.primary
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            '${valor.toInt()}',
                                            style: TextStyle(
                                              fontSize: isMobile ? 9 : 10,
                                              fontWeight: FontWeight.w800,
                                              color: AppPalette.primary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: chartHeight - 60,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              width: double.infinity,
                                              height: (chartHeight - 60) * safePorcentagem,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    AppPalette.primary,
                                                    AppPalette.primary.withOpacity(0.7),
                                                    AppPalette.accent.withOpacity(0.5),
                                                  ],
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppPalette.primary.withOpacity(0.4),
                                                    blurRadius: 6,
                                                    spreadRadius: 0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 4),
                                          child: Text(
                                            hist['data'] ?? '',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: isMobile ? 9 : 10,
                                              fontWeight: FontWeight.w600,
                                              color: AppPalette.mutedFg,
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
                  const SizedBox(height: 16),
                  const _Section('EM RELAÇÃO AOS JOGOS ANTERIORES'),
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        child: Row(children: const [
                          Expanded(
                              child: Text('DATA',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppPalette.mutedFg,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1))),
                          Expanded(
                              child: Text('VELOCIDADE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppPalette.mutedFg,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1))),
                          Expanded(
                              child: Text('DISTÂNCIA',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppPalette.mutedFg,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1))),
                        ]),
                      ),
                      ...historico.reversed.map((h) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: AppPalette.border))),
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
                                  color: AppPalette.primary.withOpacity(0.1),
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
                    borderColor: AppPalette.primary.withOpacity(0.4),
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
                                onPressed: () {},
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
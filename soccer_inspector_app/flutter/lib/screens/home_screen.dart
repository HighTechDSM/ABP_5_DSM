// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_palette.dart';
import '../widgets/common.dart';
import '../providers/jogadores_provider.dart';
import '../providers/dashboard_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
  if (!mounted) return;

  setState(() => _isLoading = true);

  final dashboardProvider = context.read<DashboardProvider>();
  final jogadoresProvider = context.read<JogadoresProvider>();

  await dashboardProvider.loadDashboardStats();
  await jogadoresProvider.loadJogadores();

  if (!mounted) return;

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
                child: Consumer2<JogadoresProvider, DashboardProvider>(
                  builder: (context, jogadoresProvider, dashboard, child) {
                    if (_isLoading || (jogadoresProvider.isLoading && jogadoresProvider.jogadores.isEmpty)) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final jogadores = jogadoresProvider.jogadores;
                    final alertas = jogadores
                        .where((j) => j['rendimento'] == 'baixo')
                        .toList();
                    final destaque = jogadores.isNotEmpty
                        ? jogadores.reduce((a, b) =>
                            (a['tendencia'] ?? -999) > (b['tendencia'] ?? -999)
                                ? a
                                : b)
                        : null;
                    final velMedia = dashboard.mediaVelocidade;
                    final distMedia = dashboard.mediaDistancia;
                    final totalSprints = dashboard.totalSprints;

                    final destaquesCount = isMobile ? 3 : (isTablet ? 4 : 5);

                    return ListView(
                      padding: EdgeInsets.fromLTRB(
                          horizontalPadding, 16, horizontalPadding, 24),
                      children: [
                        Row(
                          children: [
                            const BallLogo(size: 42),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('BOA NOITE',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppPalette.mutedFg,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.w700)),
                                  Text('Comissão técnica',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                            _IconBtn(
                                icon: Icons.notifications_outlined,
                                badge: true,
                                onTap: () {}),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const _SectionTitle('RESUMO DA RODADA'),
                        Row(
                          children: [
                            Expanded(
                                child: _Stat(
                                    icon: Icons.bolt,
                                    label: 'Vel. méd.',
                                    value: velMedia,
                                    unit: 'km/h',
                                    isMobile: isMobile)),
                            const SizedBox(width: 8),
                            Expanded(
                                child: _Stat(
                                    icon: Icons.route_outlined,
                                    label: 'Dist. méd.',
                                    value: distMedia,
                                    unit: 'km',
                                    isMobile: isMobile)),
                            const SizedBox(width: 8),
                            Expanded(
                                child: _Stat(
                                    icon: Icons.local_fire_department_outlined,
                                    label: 'Sprints',
                                    value: '$totalSprints',
                                    unit: 'total',
                                    isMobile: isMobile)),
                          ],
                        ),
                        if (alertas.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          GlassCard(
                            borderColor: AppPalette.danger.withValues(alpha: 0.45),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppPalette.danger
                                            .withValues(alpha: 0.18),
                                        borderRadius: AppPalette.radiusMd),
                                    child: const Icon(
                                        Icons.warning_amber_rounded,
                                        color: AppPalette.danger,
                                        size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${alertas.length} jogador(es) abaixo do padrão',
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.w700)),
                                          const SizedBox(height: 2),
                                          Text(
                                              '${alertas
                                                  .map((a) =>
                                                      (a['nome'] ?? '')
                                                          .split(' ')
                                                          .first)
                                                  .join(', ')} apresentam queda.',
                                              style: const TextStyle(
                                                  color: AppPalette.mutedFg,
                                                  fontSize: 12)),
                                        ]),
                                  ),
                                ]),
                          ),
                        ],
                        if (destaque != null) ...[
                          const SizedBox(height: 20),
                          const _SectionTitle('DESTAQUE DO DIA'),
                          InkWell(
                            borderRadius: AppPalette.radiusLg,
                            onTap: () => Navigator.pushNamed(
                              context, 
                              '/jogador', 
                              arguments: {
                                'id': destaque['id'] ?? destaque['athleteId'] ?? destaque['Athlete ID'],
                                'nome': destaque['nome']
                              }
                            ),
                            child: GlassCard(
                              child: Row(children: [
                                JerseyAvatar(numero: destaque['numero'] ?? 0),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(destaque['nome'] ?? '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        Text(
                                            '${destaque['posicao'] ?? ''} · ${destaque['perfil'] ?? 'Regular'}',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color: AppPalette.mutedFg)),
                                      ]),
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Row(children: [
                                        const Icon(Icons.trending_up,
                                            size: 14,
                                            color: AppPalette.success),
                                        const SizedBox(width: 2),
                                        Text(
                                            '+${destaque['tendencia'] ?? 0}%',
                                            style: const TextStyle(
                                                color: AppPalette.success,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800)),
                                      ]),
                                      const Text('vs. média',
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: AppPalette.mutedFg)),
                                    ]),
                              ]),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        const _SectionTitle('ATLETAS EM DESTAQUE'),
                        ...jogadores.take(destaquesCount).map((j) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: InkWell(
                                borderRadius: AppPalette.radiusLg,
                                onTap: () => Navigator.pushNamed(
                                  context, 
                                  '/jogador', 
                                  arguments: {
                                    'id': j['id'] ?? j['athleteId'] ?? j['Athlete ID'],
                                    'nome': j['nome']
                                  }
                                ),
                                child: GlassCard(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  child: Row(children: [
                                    JerseyAvatar(
                                        numero: j['numero'] ?? 0,
                                        size: isMobile ? 36 : 40),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(j['nome'] ?? '',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    fontSize:
                                                        isMobile ? 14 : 15)),
                                            Text(
                                                '${j['posicao'] ?? ''} · ${j['perfil'] ?? 'Regular'}',
                                                style: const TextStyle(
                                                    fontSize: 11,
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
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

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label, value, unit;
  final bool isMobile;
  const _Stat(
      {required this.icon,
      required this.label,
      required this.value,
      required this.unit,
      required this.isMobile});

  @override
  Widget build(BuildContext context) => GlassCard(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, size: 16, color: AppPalette.primary),
          const SizedBox(height: 8),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: value,
                style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w800,
                    color: AppPalette.foreground)),
            TextSpan(
                text: ' $unit',
                style: const TextStyle(fontSize: 10, color: AppPalette.mutedFg)),
          ])),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 10, color: AppPalette.mutedFg)),
        ]),
      );
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool badge;
  final VoidCallback onTap;
  const _IconBtn(
      {required this.icon, this.badge = false, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppPalette.radiusMd,
      child: Stack(children: [
        Container(
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
        if (badge)
          const Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(radius: 4, backgroundColor: AppPalette.danger)),
      ]),
    );
  }
}
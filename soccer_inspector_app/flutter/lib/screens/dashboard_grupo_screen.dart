// lib/screens/dashboard_grupo_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_palette.dart';
import '../widgets/common.dart';

class DashboardGrupoScreen extends StatelessWidget {
  const DashboardGrupoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String grupoNome = args['grupo'];
    final List<dynamic> jogadores = args['jogadores'];
    final int total = args['total'];
    final int otimos = args['otimos'];
    final int regulares = args['regulares'];
    final int baixos = args['baixos'];

    String getRendimentoLabel(String rendimento) {
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

    Color getRendimentoColor(String rendimento) {
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

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppPalette.pitchGradient),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    _IconBtn(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'DASHBOARD',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppPalette.mutedFg,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            grupoNome,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        'Total',
                        total.toString(),
                        AppPalette.accent,
                        Icons.groups,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statCard(
                        'Ótimo',
                        otimos.toString(),
                        AppPalette.success,
                        Icons.emoji_events,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statCard(
                        'Regular',
                        regulares.toString(),
                        AppPalette.warning,
                        Icons.bolt,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statCard(
                        'Baixo',
                        baixos.toString(),
                        AppPalette.danger,
                        Icons.warning_amber_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const Text(
                      'JOGADORES DO GRUPO',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppPalette.mutedFg,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...jogadores.map((j) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            borderRadius: AppPalette.radiusLg,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/jogador',
                              arguments: j['nome'],
                            ),
                            child: GlassCard(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Row(
                                children: [
                                  JerseyAvatar(numero: j['numero'] ?? 0),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          j['nome'] ?? '',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Vel: ${j['velocidadeMax']} km/h · Dist: ${j['distancia']} km',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: AppPalette.mutedFg),
                                        ),
                                      ],
                                    ),
                                  ),
                                  StatusPill(
                                    label:
                                        getRendimentoLabel(j['rendimento']),
                                    color: getRendimentoColor(j['rendimento']),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: AppPalette.radiusSm,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppPalette.mutedFg,
            ),
          ),
        ],
      ),
    );
  }
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
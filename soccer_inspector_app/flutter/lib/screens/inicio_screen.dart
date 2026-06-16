import 'package:flutter/material.dart';
import '../theme/app_palette.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return Scaffold(
          backgroundColor: const Color(0xFF020B08),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: const [
                  Color(0xFF032414),
                  Color(0xFF010806),
                  Colors.black,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: isWide ? 60 : 40),
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            gradient: AppPalette.primaryGradient,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: AppPalette.primary.withOpacity(0.35),
                                blurRadius: 40,
                                spreadRadius: 1,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.sports_soccer,
                            color: Color(0xFF05120B),
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 28),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'SOCCER ',
                                style: TextStyle(
                                  color: AppPalette.primary,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.8,
                                  height: 1,
                                ),
                              ),
                              TextSpan(
                                text: 'Inspector',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.8,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Análise inteligente de desempenho físico de atletas com IA.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFA6B0AA),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              height: 1.55,
                            ),
                          ),
                        ),
                        const SizedBox(height: 34),
                        Row(
                          children: [
                            Expanded(
                              child: _featureCard(
                                icon: Icons.monitor_heart_outlined,
                                title: 'Rendimento',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _featureCard(
                                icon: Icons.psychology_outlined,
                                title: 'IA preditiva',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _featureCard(
                                icon: Icons.shield_outlined,
                                title: 'Alertas',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 38),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: AppPalette.primaryGradient,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: AppPalette.primary.withOpacity(0.35),
                                  blurRadius: 28,
                                  spreadRadius: 0.5,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Entrar no app',
                                      style: TextStyle(
                                        color: Color(0xFF04110A),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 20,
                                      color: Color(0xFF04110A),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/cadastro');
                          },
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Não tem conta? ',
                                  style: TextStyle(
                                    color: Color(0xFFA6B0AA),
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Cadastre-se',
                                  style: TextStyle(
                                    color: AppPalette.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _featureCard({
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: const [
            Color(0xFF0A1712),
            Color(0xFF07120E),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppPalette.primary,
            size: 24,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFA6B0AA),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
// lib/screens/cadastro_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_palette.dart';
import '../widgets/common.dart';
import '../providers/auth_provider.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(gradient: AppPalette.pitchGradient),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 24,
                    ),
                    child: Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: isWide ? 60 : 40),
                            const BallLogo(size: 56),
                            const SizedBox(height: 16),
                            const Text(
                              'Criar conta',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Acesse o painel da comissão técnica.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppPalette.mutedFg,
                              ),
                            ),
                            const SizedBox(height: 36),
                            if (auth.error != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: AppPalette.danger.withValues(alpha: 0.18),
                                  borderRadius: AppPalette.radiusMd,
                                ),
                                child: Text(
                                  auth.error!,
                                  style: const TextStyle(
                                      color: AppPalette.danger, fontSize: 12),
                                ),
                              ),
                            _field(
                              label: 'NOME COMPLETO',
                              icon: Icons.person_outline,
                              hint: 'Seu nome',
                              controller: nameController,
                            ),
                            const SizedBox(height: 16),
                            _field(
                              label: 'E-MAIL',
                              icon: Icons.mail_outline,
                              hint: 'seu@email.com',
                              controller: emailController,
                            ),
                            const SizedBox(height: 16),
                            _field(
                              label: 'CRIAR SENHA',
                              icon: Icons.lock_outline,
                              hint: 'Mínimo 8 caracteres',
                              obscure: true,
                              controller: passwordController,
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: PrimaryButton(
                                label:
                                    auth.isLoading ? 'Cadastrando...' : 'Cadastrar',
                                icon: Icons.arrow_forward_rounded,
                                onPressed: auth.isLoading
                                    ? null
                                    : () async {
                                        final success = await auth.register(
                                          nameController.text.trim(),
                                          emailController.text.trim(),
                                          passwordController.text.trim(),
                                        );
                                        if (success && context.mounted) {
                                          Navigator.pushReplacementNamed(
                                              context, '/app');
                                        }
                                      },
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, '/login'),
                              child: const Text.rich(
                                TextSpan(
                                  text: 'Já tem conta? ',
                                  style: TextStyle(color: AppPalette.mutedFg),
                                  children: [
                                    TextSpan(
                                      text: 'Fazer login',
                                      style: TextStyle(
                                        color: AppPalette.primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
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
      },
    );
  }

  Widget _field({
    required String label,
    required IconData icon,
    required String hint,
    bool obscure = false,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppPalette.mutedFg,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18),
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
# SOCCER Inspector — Flutter

Estrutura espelhada do protótipo web. Todas as cores vêm de
`lib/theme/app_palette.dart` — troque os valores no topo do arquivo
para mudar a paleta inteira do app.

## Estrutura

```
lib/
├── main.dart                        # Rotas + bottom-nav shell
├── theme/
│   └── app_palette.dart             # ← TOKENS DE COR (trocar aqui)
├── data/
│   └── mock_data.dart               # Jogadores, histórico, mensagens IA
├── widgets/
│   └── common.dart                  # BallLogo, GlassCard, JerseyAvatar...
└── screens/
    ├── login_screen.dart
    ├── cadastro_screen.dart
    ├── home_screen.dart             # /app  → resumo + alertas + destaque
    ├── jogadores_screen.dart        # /app/jogadores
    ├── analise_screen.dart          # /jogador (detalhe + gráfico + IA)
    ├── dashboard_screen.dart        # /app/dashboard
    └── perfis_screen.dart           # /app/perfis
```

## Como usar

1. Crie um projeto Flutter novo:
   ```bash
   flutter create soccer_inspector
   cd soccer_inspector
   ```
2. Substitua a pasta `lib/` por esta.
3. Rode:
   ```bash
   flutter run
   ```

## Trocar a paleta de cores

Abra `lib/theme/app_palette.dart` e altere os 6 hex no topo.
Sugestões prontas estão comentadas no próprio arquivo:

- Verde neon esportivo (default) — `#04E762`, `#80ED99`
- Azul tático — `#57CC99`, `#22577A`
- Multicolor vibrante — `#DC0073`, `#008BF8`, `#F5B700`
- Tech roxo + ciano — `#7014F2`, `#21B0FE`, `#00F59B`

## Próximos passos sugeridos

- Substituir o `_SparklinePainter` por `fl_chart` para gráficos interativos:
  `flutter pub add fl_chart`
- Conectar `data/mock_data.dart` à API real do backend (ML).
- Adicionar `provider` ou `riverpod` para gerenciar estado.

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:meu_curriculo_flutter/core/constants/app_constants.dart';
import 'package:meu_curriculo_flutter/core/theme/app_theme.dart';
import 'package:meu_curriculo_flutter/data/repositories/portfolio_repository.dart';
import 'package:meu_curriculo_flutter/data/repositories/supabase_repository.dart';
import 'package:meu_curriculo_flutter/l10n/arb/app_localizations.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/auth_controller.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/portfolio_controller.dart';
import 'package:meu_curriculo_flutter/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(const MeuCurriculoApp());
}

class MeuCurriculoApp extends StatelessWidget {
  const MeuCurriculoApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Injeta o Repositório (SupabaseRepository)
        Provider<IPortfolioRepository>(create: (_) => SupabaseRepository()),

        // 2. Injeta o PortfolioController (Usa o repositório acima)
        ChangeNotifierProvider<PortfolioController>(
          create: (final context) =>
              PortfolioController(context.read<IPortfolioRepository>()),
        ),

        // 3. Injeta o AuthController (NOVO! Faltava isso)
        ChangeNotifierProvider<AuthController>(
          create: (final context) {
            // Pegamos o repositório injetado e convertemos para SupabaseRepository
            // pois o AuthController precisa dos métodos de login (que não estão na interface genérica)
            final repo =
                context.read<IPortfolioRepository>() as SupabaseRepository;
            return AuthController(repo);
          },
        ),
      ],
      child: Consumer<PortfolioController>(
        builder: (final context, final controller, final child) {
          return MaterialApp(
            onGenerateTitle: (final context) =>
                AppLocalizations.of(context)!.appTitle,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: controller.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

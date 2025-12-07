// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/portfolio_repository.dart';
import 'data/repositories/supabase_repository.dart';
import 'presentation/controllers/portfolio_controller.dart';
import 'presentation/pages/home_page.dart';

import 'presentation/controllers/auth_controller.dart'; // <--- Importe o AuthController

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(const MeuCurriculoApp());
}

class MeuCurriculoApp extends StatelessWidget {
  const MeuCurriculoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Injeta o Repositório (SupabaseRepository)
        Provider<IPortfolioRepository>(create: (_) => SupabaseRepository()),

        // 2. Injeta o PortfolioController (Usa o repositório acima)
        ChangeNotifierProvider<PortfolioController>(
          create: (context) =>
              PortfolioController(context.read<IPortfolioRepository>()),
        ),

        // 3. Injeta o AuthController (NOVO! Faltava isso)
        ChangeNotifierProvider<AuthController>(
          create: (context) {
            // Pegamos o repositório injetado e convertemos para SupabaseRepository
            // pois o AuthController precisa dos métodos de login (que não estão na interface genérica)
            final repo =
                context.read<IPortfolioRepository>() as SupabaseRepository;
            return AuthController(repo);
          },
        ),
      ],
      child: Consumer<PortfolioController>(
        builder: (context, controller, child) {
          return MaterialApp(
            title: 'Franklyn Roberto - Portfólio',
            debugShowCheckedModeBanner: false,
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

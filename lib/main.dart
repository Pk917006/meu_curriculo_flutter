import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importe isso
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'data/repositories/portfolio_repository.dart';
import 'data/repositories/supabase_repository.dart'; // Vamos criar este arquivo jájá
import 'presentation/controllers/portfolio_controller.dart';
import 'presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Carrega o arquivo .env
  await dotenv.load(fileName: ".env");

  // 2. Inicializa o Supabase usando as constantes (que agora leem do .env)
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
        // 3. TROCA DE CHAVE: De MOCK para SUPABASE
        // Antes: Provider<IPortfolioRepository>(create: (_) => PortfolioRepository()),
        // Agora:
        Provider<IPortfolioRepository>(create: (_) => SupabaseRepository()),

        ChangeNotifierProvider<PortfolioController>(
          create: (context) =>
              PortfolioController(context.read<IPortfolioRepository>()),
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

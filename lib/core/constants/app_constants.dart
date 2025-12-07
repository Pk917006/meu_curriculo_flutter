// Flutter imports:

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppAssets {
  // Imagens (baseado nos arquivos que você subiu)
  static const String profileImage = 'assets/img/minha_foto.jpg';

  // Documentos
  static const String cvPtBr =
      'assets/docs/curriculo_2024_Franklyn_Roberto.pdf';
}

class AppStrings {
  // Textos Gerais
  static const String portfolioTitle = 'Franklyn Roberto';
  static const String role = 'MOBILE DEVELOPER';
  static const String aboutMe =
      'Bacharel em Ciência da Computação (UFAL). Desenvolvedor focado em soluções Mobile com Flutter. Experiência em aplicações escaláveis, microserviços e arquitetura limpa.';

  // Links Sociais
  static const String linkedInUrl =
      'https://www.linkedin.com/in/franklyn-roberto-dev/';
  static const String gitHubUrl = 'https://github.com/Franklyn-R-Silva';
  static const String whatsappUrl =
      'https://api.whatsapp.com/send?phone=5582999915558';
  static const String emailUrl = 'mailto:franklyn.dev.mobile@gmail.com';
}

class AppColors {
  // Paleta de cores
  static const int primary = 0xFF3845BD;
  static const int backgroundLight = 0xFFF9F9F9;
  static const int surfaceWhite = 0xFFFFFFFF;
}

class AppConstants {
  // Agora buscamos as chaves do arquivo oculto com segurança
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static const String profileImage = 'assets/img/minha_foto.jpg';
  static const String cvPtBr =
      'assets/docs/curriculo_2024_Franklyn_Roberto.pdf';
}

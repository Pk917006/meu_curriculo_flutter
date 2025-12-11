// Project imports:
import 'package:meu_curriculo_flutter/data/models/certificate_model.dart';
import 'package:meu_curriculo_flutter/data/models/experience_model.dart';
import 'package:meu_curriculo_flutter/data/models/project_model.dart';
import 'package:meu_curriculo_flutter/data/models/skill_model.dart';

class MockData {
  // --- EXPERIÊNCIAS, PROJETOS E SKILLS ATUALIZADOS ---
  static const List<ExperienceModel> experiences = [
    ExperienceModel(
      role: 'Desenvolvedor Mobile',
      company: 'NWERP',
      period: 'Out 2025 - Atualmente',
      description:
          'Criação de um sistema abrangente de gestão de vendas B2B e pré-faturamento construído com Flutter e Supabase. Esta aplicação web e mobile agiliza a gestão de clientes, navegação no catálogo de produtos e processamento de pedidos para equipes de vendas.',
    ),
    ExperienceModel(
      role: 'Analista de sistemas',
      company: 'Grupo Coagro',
      period: 'Jul 2024 - Atualmente',
      description:
          'Desenvolvedor Mobile (Flutter) e de APIs (Node.js/TS), com foco na otimização de Logística (endereçamento/etiquetas), Vendas (CRM de Campo, faturamento de NFs e apps de loja) e na gestão operacional de sistemas críticos, possuindo experiência com WinThor e Oracle DB.',
    ),
    ExperienceModel(
      role: 'Desenvolvedor Fullstack',
      company: 'Plussoft',
      period: 'Jul 2023 - Dez 2023',
      description:
          'Desenvolvimento de aplicativos Desktop com Electron (backup e envio de arquivos). Manutenção em APIs, criação de rotas e integração com SQL Server e MySQL. Manutenção de front-end React.',
    ),
    ExperienceModel(
      role: 'Analista de Sistemas',
      company: 'Open Consult',
      period: 'Jun 2023 - Jul 2023',
      description:
          'Desenvolvimento e implementação de políticas estratégicas de IAM e fluxos de trabalho de segurança.',
    ),
    ExperienceModel(
      role: 'Monitor de P.O.O.',
      company: 'UFAL',
      period: 'Set 2022 - Fev 2023',
      description:
          'Ensino de Programação Orientada a Objetos utilizando Java, Spring MVC e Design Patterns. Auxílio aos alunos em projetos práticos.',
    ),
  ];

  static const List<ProjectModel> projects = [
    // ... (Copie seus projetos antigos aqui)
    ProjectModel(
      title: 'ImageLite',
      description:
          'Fullstack App com Spring Boot, React e Docker. Inclui autenticação JWT, PostgreSQL e upload de imagens.',
      techStack: ['Java', 'Spring Boot', 'React', 'Docker', 'PostgreSQL'],
      repoUrl: 'https://github.com/DevFullStack-Franklyn-R-Silva/ImageLite',
    ),
    ProjectModel(
      title: 'TCC - Livraria em Nuvem',
      description:
          'Aplicação escalável baseada em microsserviços para uma livraria mundial. Foco em alta performance e escalabilidade.',
      techStack: ['Microservices', 'Cloud', 'Java', 'Spring Cloud'],
      repoUrl:
          'https://github.com/DevFullStack-Franklyn-R-Silva/Desenvolvimento-de-aplicacao-em-nuvem-escalavel',
    ),
    ProjectModel(
      title: 'Calculadora Flutter',
      description:
          'App mobile de calculadora desenvolvido em Dart/Flutter. Demonstração de gerenciamento de estado e UI responsiva.',
      techStack: ['Flutter', 'Dart', 'Android', 'iOS'],
      repoUrl:
          'https://github.com/DevFullStack-Franklyn-R-Silva/Calculadora-em-Dart_Flutter',
    ),
  ];

  // --- SKILLS ATUALIZADAS E CATEGORIZADAS ---
  static const List<SkillModel> skills = [
    // 📱 MOBILE (CORE)
    SkillModel(name: 'Flutter', type: SkillType.mobile, isHighlight: true),
    SkillModel(name: 'Dart', type: SkillType.mobile, isHighlight: true),
    SkillModel(name: 'React Native', type: SkillType.mobile),
    SkillModel(name: 'Kotlin', type: SkillType.mobile),
    SkillModel(name: 'Swift', type: SkillType.mobile),
    SkillModel(name: 'Java (Android)', type: SkillType.mobile),
    SkillModel(name: 'Android Studio', type: SkillType.mobile),

    // 💻 WEB, BACKEND & DESKTOP
    SkillModel(name: 'Node.js', type: SkillType.web, isHighlight: true),
    SkillModel(name: 'TypeScript', type: SkillType.web, isHighlight: true),
    SkillModel(name: 'JavaScript', type: SkillType.web),
    SkillModel(name: 'Electron', type: SkillType.web),
    SkillModel(name: 'Spring Boot', type: SkillType.web),
    SkillModel(name: 'Docker', type: SkillType.web, isHighlight: true),
    SkillModel(name: 'Oracle', type: SkillType.web, isHighlight: true),
    SkillModel(name: 'PostgreSQL', type: SkillType.web),
    SkillModel(name: 'MySQL', type: SkillType.web),
    SkillModel(name: 'HTML5 & CSS3', type: SkillType.web),
    SkillModel(name: 'Tailwind CSS', type: SkillType.web),
    SkillModel(name: 'Bootstrap', type: SkillType.web),

    // ⚙️ TOOLS
    SkillModel(name: 'Git', type: SkillType.tools, isHighlight: true),
    SkillModel(name: 'GitHub', type: SkillType.tools, isHighlight: true),
    SkillModel(name: 'VS Code', type: SkillType.tools),
    SkillModel(name: 'Postman', type: SkillType.tools),
    SkillModel(name: 'Figma', type: SkillType.tools),
    SkillModel(name: 'FlutterFlow', type: SkillType.tools),
    SkillModel(name: 'Xcode', type: SkillType.tools),
    SkillModel(name: 'Supabase', type: SkillType.tools, isHighlight: true),
    SkillModel(name: 'Linux', type: SkillType.tools),
  ];

  static const List<CertificateModel> certificates = [
    CertificateModel(
      title: 'Flutter & Dart - The Complete Guide',
      issuer: 'Udemy',
      date: '2024',
      description: 'Complete guide to Flutter and Dart development',
      language: 'Dart',
      framework: 'Flutter',
      credentialUrl: 'https://www.udemy.com/certificate/UC-XXXXX/',
    ),
    CertificateModel(
      title: 'Clean Architecture em Flutter',
      issuer: 'Udemy',
      date: '2024',
      description: 'Clean Architecture principles applied to Flutter',
      language: 'Dart',
      framework: 'Flutter',
      credentialUrl: '',
    ),
    CertificateModel(
      title: 'Ignite - React Native',
      issuer: 'Rocketseat',
      date: '2023',
      description: 'React Native development with Ignite',
      language: 'Typescript',
      framework: 'React Native',
      credentialUrl: '',
    ),
  ];
}

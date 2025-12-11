# 🚀 Meu Portfólio - Flutter Web Experience

[![Tech Stack](https://go-skill-icons.vercel.app/api/icons?i=flutter,dart,supabase,vscode,androidstudio,git,github)](https://github.com/DevFullStack-Franklyn-R-Silva/meu_curriculo_flutter)

![Architecture](https://img.shields.io/badge/Architecture-MVVM%20%2B%20Repository%20Pattern-green)
![State Management](https://img.shields.io/badge/State-Provider-blueviolet)
![Backend](https://img.shields.io/badge/Backend-Supabase-3ECF8E)
![Design Pattern](https://img.shields.io/badge/Design-Atomic%20Design-orange)

> Um portfólio **interativo e responsivo** desenvolvido com **Flutter Web**, integrando **Supabase** como backend e demonstrando **arquitetura profissional**, UI/UX avançada, animações complexas e gerenciamento de estado robusto.

---

## 🎨 Funcionalidades & Destaques

Este projeto vai além de uma simples landing page estática. Ele implementa conceitos avançados de renderização, interatividade e arquitetura:

### 🎯 **Funcionalidades Principais**

- **🔐 Sistema de Autenticação:** Login com Supabase Auth e persistência de sessão
- **📊 Painel Admin (CRUD Completo):** Gerenciamento de projetos, experiências, habilidades e certificados em tempo real
- **🌐 Internacionalização (i18n):** Suporte para múltiplos idiomas (PT-BR e EN)
- **🌓 Dark Mode:** Alternância entre tema claro e escuro com persistência

### ✨ **UI/UX Avançada**

- **🌌 Hero Section com Física:** Ícones de tecnologia com efeito magnético reverso (repulsão ao mouse)
- **🧊 Header Glassmorphism:** Navegação flutuante com blur e transparência dinâmica
- **🖥️ Cards Holográficos 3D:** Efeito tilt 3D seguindo o cursor com iluminação dinâmica
- **⚡ Animações Fluidas:** Micro-interações com `flutter_animate` e animações customizadas
- **📱 Totalmente Responsivo:** Layout adaptativo para Mobile, Tablet e Desktop
- **🎬 Intro Animada:** Loading screen estilo terminal hacker com efeitos de digitação

---

## 🛠️ Stack Tecnológica

### **Core**

- **Linguagem:** [Dart 3.x](https://dart.dev/)
- **Framework:** [Flutter 3.27+](https://flutter.dev/) (Web, Android, iOS)
- **Backend:** [Supabase](https://supabase.com/) (PostgreSQL + Auth + Storage)

### **Arquitetura & Padrões**

- **Padrão de Projeto:** MVVM + Repository Pattern + Clean Architecture Elements
- **Gerência de Estado:** `provider` (ChangeNotifier)
- **Injeção de Dependência:** Provider DI
- **Design System:** Atomic Design (Atoms → Molecules → Organisms)

### **Bibliotecas Principais**

- **Animações:** `flutter_animate`, `AnimationController` customizados
- **UI Components:** `google_fonts`, `font_awesome_flutter`
- **Networking:** `supabase_flutter`, `http`
- **Utilidades:** `url_launcher`, `flutter_dotenv`
- **Internacionalização:** `flutter_localizations`, ARB files

---

## 📂 Estrutura do Projeto (Clean Architecture)

O projeto segue uma estrutura **Atomic Design** misturada com **Clean Architecture** para garantir escalabilidade e manutenção:

```bash
lib/
├── core/                  # Configurações globais (Temas, Constantes, Utils)
├── data/                  # Camada de Dados
│   ├── mocks/             # Dados estáticos (Currículo, Projetos)
│   ├── models/            # Modelos de dados (ProjectModel, SkillModel)
│   └── repositories/      # Contratos e Implementações de Repositório
├── presentation/          # Camada de UI
│   ├── controllers/       # Lógica de Estado (PortfolioController)
│   ├── pages/             # Telas principais (HomePage)
│   └── widgets/           # Componentes Visuais (Atomic Design)
│       ├── atoms/         # Botões, Chips, Elementos Magnéticos
│       ├── molecules/     # Cards Interativos (ProjectCard, ExperienceCard)
│       └── organisms/     # Seções completas (Hero, Skills, Projects)
└── main.dart              # Ponto de entrada e Injeção de Dependências
```

---

## 🏗️ Arquitetura do Projeto

### **Padrão Arquitetural: MVVM + Repository Pattern + Clean Architecture Elements**

O projeto implementa uma arquitetura híbrida robusta que combina os melhores aspectos de MVVM, Repository Pattern e Clean Architecture:

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                           │
│  ┌────────────────┐           ┌──────────────────────────────┐     │
│  │                │  Provider │                              │     │
│  │     VIEW       │◄─────────►│      VIEW MODEL              │     │
│  │   (Pages +     │   Binding │    (Controllers)             │     │
│  │    Widgets)    │           │                              │     │
│  │                │           │ • PortfolioController        │     │
│  └────────────────┘           │ • AuthController             │     │
│   • home_page.dart            │                              │     │
│   • admin_dashboard_page.dart │ State Management: Provider   │     │
│   • Atomic Design Components  │ (ChangeNotifier Pattern)     │     │
│                                └──────────────┬───────────────┘     │
└───────────────────────────────────────────────┼─────────────────────┘
                                                │
                                                │ Dependency
                                                │ Injection
                                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│                          DATA LAYER                                 │
│                                                                     │
│   ┌─────────────────────────────────────────────────────────┐     │
│   │          Repository Interface (Contract)                │     │
│   │                                                         │     │
│   │      abstract class IPortfolioRepository {             │     │
│   │        Future<List<Project>> getProjects();            │     │
│   │        Future<void> addProject(Project project);       │     │
│   │      }                                                  │     │
│   └───────────────────────┬─────────────────────────────────┘     │
│                           │ implements                            │
│                           ↓                                       │
│   ┌─────────────────────────────────────────────────────────┐     │
│   │    Repository Implementation                            │     │
│   │                                                         │     │
│   │    class SupabaseRepository                            │     │
│   │    implements IPortfolioRepository {                   │     │
│   │                                                         │     │
│   │      • getProjects()                                   │     │
│   │      • getExperiences()                                │     │
│   │      • getSkills()                                     │     │
│   │      • getCertificates()                               │     │
│   │      • CRUD Operations                                 │     │
│   │      • Error Handling                                  │     │
│   │      • Logging                                         │     │
│   │    }                                                    │     │
│   └───────────────────────┬─────────────────────────────────┘     │
│                           │                                       │
│                           ↓                                       │
│   ┌─────────────────────────────────────────────────────────┐     │
│   │              MODELS (Entities)                          │     │
│   │                                                         │     │
│   │   • ProjectModel         • SkillModel                  │     │
│   │   • ExperienceModel      • CertificateModel            │     │
│   │                                                         │     │
│   │   Responsibilities:                                    │     │
│   │   - Data structure definition                          │     │
│   │   - JSON serialization (toMap/fromMap)                 │     │
│   │   - Type validation                                    │     │
│   └───────────────────────┬─────────────────────────────────┘     │
│                           │                                       │
└───────────────────────────┼───────────────────────────────────────┘
                            │
                            ↓
┌─────────────────────────────────────────────────────────────────────┐
│                      EXTERNAL DATA SOURCE                           │
│                                                                     │
│                    ┌─────────────────────┐                          │
│                    │     SUPABASE        │                          │
│                    │                     │                          │
│                    │  • PostgreSQL DB    │                          │
│                    │  • Auth System      │                          │
│                    │  • Real-time Sync   │                          │
│                    │  • Row Level Sec.   │                          │
│                    └─────────────────────┘                          │
└─────────────────────────────────────────────────────────────────────┘
```

### **Fluxo de Dados**

```
USER INTERACTION
      ↓
┌──────────────────────┐
│   View (Widget)      │  → User taps button, enters text
└──────────┬───────────┘
           │
           ↓ Event (onPressed, onChange)
┌──────────────────────┐
│   ViewModel          │  → Receives event, updates state
│   (Controller)       │  → Calls repository methods
└──────────┬───────────┘
           │
           ↓ Method call
┌──────────────────────┐
│   Repository         │  → Handles data operations
│   (Data Layer)       │  → Interacts with Supabase
└──────────┬───────────┘
           │
           ↓ HTTP/gRPC
┌──────────────────────┐
│   Supabase API       │  → Returns data
└──────────┬───────────┘
           │
           ↓ Response
┌──────────────────────┐
│   Repository         │  → Converts to Models
└──────────┬───────────┘
           │
           ↓ Models
┌──────────────────────┐
│   ViewModel          │  → Updates state
│   (Controller)       │  → notifyListeners()
└──────────┬───────────┘
           │
           ↓ State change
┌──────────────────────┐
│   View (Widget)      │  → Rebuilds with new data
└──────────────────────┘
```

### **Princípios Aplicados**

#### ✅ **SOLID Principles**

- **S** - Single Responsibility: Cada classe tem uma responsabilidade única
- **O** - Open/Closed: Extensível via interfaces (IPortfolioRepository)
- **L** - Liskov Substitution: SupabaseRepository pode ser substituído por MockRepository
- **I** - Interface Segregation: Interfaces específicas para cada tipo de repositório
- **D** - Dependency Inversion: Controllers dependem de abstrações (interfaces)

#### ✅ **Design Patterns**

- **Repository Pattern**: Abstração da camada de dados
- **MVVM**: Separação entre View e lógica de negócio
- **Dependency Injection**: Provider para injeção de dependências
- **Observer Pattern**: ChangeNotifier para reatividade
- **Atomic Design**: Componentização hierárquica de UI

### **Benefícios da Arquitetura**

| Benefício               | Descrição                                                   |
| ----------------------- | ----------------------------------------------------------- |
| **🧪 Testabilidade**    | Fácil criar mocks para testes unitários                     |
| **🔧 Manutenibilidade** | Mudanças isoladas não afetam outras camadas                 |
| **📈 Escalabilidade**   | Fácil adicionar novas features sem quebrar código existente |
| **🔄 Reusabilidade**    | Componentes podem ser reutilizados em diferentes contextos  |
| **👥 Colaboração**      | Estrutura clara facilita trabalho em equipe                 |
| **🐛 Debugging**        | Fluxo de dados previsível facilita identificação de bugs    |

---

## 🚀 Como Rodar o Projeto

### Pré-requisitos

Certifique-se de ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.

1.  **Clone o repositório:**

    ```bash
    git clone [https://github.com/DevFullStack-Franklyn-R-Silva/meu_curriculo_flutter.git](https://github.com/DevFullStack-Franklyn-R-Silva/meu_curriculo_flutter.git)
    cd meu_curriculo_flutter
    ```

2.  **Instale as dependências:**

    ```bash
    flutter pub get
    ```

3.  **Rode no Chrome:**

    ```bash
    flutter run -d chrome
    ```

---

## 📦 Como Fazer o Deploy (GitHub Pages)

Para gerar a versão de produção e hospedar gratuitamente:

```bash
# Gere o build de web (substitua o href pelo nome do seu repositório)
flutter build web --release --base-href "/meu_curriculo_flutter/"

# O conteúdo gerado estará na pasta /build/web
```

---

## 👨‍💻 Autor

**Franklyn Roberto** _Mobile Developer (Flutter) & Fullstack_

[](https://www.linkedin.com/in/franklyn-roberto-dev/)
[](https://github.com/DevFullStack-Franklyn-R-Silva)

---

Desenvolvido com 💙 e Flutter.

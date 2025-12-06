# 🚀 Meu Portfólio - Flutter Web Experience

[![Tech Stack](https://go-skill-icons.vercel.app/api/icons?i=flutter,dart,vscode,androidstudio,git,github)](https://github.com/coagro-lab/coagro-app-supabase)

![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20MVVM-green)
![State Management](https://img.shields.io/badge/State-Provider-blueviolet)

> Um portfólio interativo e responsivo desenvolvido com **Flutter Web**, focado em demonstrar UI/UX avançada, física, animações complexas e arquitetura de software limpa.

---

## 🎨 Funcionalidades & Destaques

Este projeto vai além de uma simples landing page estática. Ele implementa conceitos avançados de renderização e interatividade:

- **🌌 Hero Section com Física (Gravity/Magnetic):** Ícones de tecnologia que reagem à proximidade do mouse, simulando um campo magnético reverso.
- **🧊 Header Glassmorphism:** Barra de navegação flutuante com efeito de desfoque (blur) e transparência em tempo real.
- **🖥️ Cards Holográficos 3D:** Os cards de projeto inclinam em 3D (Tilt Effect) seguindo a posição do cursor, com iluminação dinâmica.
- **✨ Animações Fluidas:** Uso extensivo do pacote `flutter_animate` para entradas em cascata e micro-interações.
- **📱 Totalmente Responsivo:** Layout adaptativo que funciona perfeitamente em Mobile, Tablet e Desktop (Web).

---

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** [Dart](https://dart.dev/)
- **Framework:** [Flutter](https://flutter.dev/) (Foco em Web)
- **Gerência de Estado:** `provider` (Padrão ChangeNotifier)
- **Animações:** `flutter_animate` + `AnimationController` nativo (para física)
- **Fontes & Ícones:** `google_fonts`, `font_awesome_flutter`
- **Links Externos:** `url_launcher`

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

```

### Por que esse README é bom?
1.  **Badges:** Dão um ar técnico imediato.
2.  **Destaques Técnicos:** Explica *o que* você fez de diferente (Física, 3D, Glassmorphism). Isso mostra que você não apenas copiou um template.
3.  **Árvore de Arquivos:** Mostra que você sabe organizar código (senioridade).
4.  **Instruções Claras:** Qualquer pessoa consegue baixar e rodar.
```

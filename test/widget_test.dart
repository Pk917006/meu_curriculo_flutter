// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:meu_curriculo_flutter/data/repositories/portfolio_repository.dart';
import 'package:meu_curriculo_flutter/l10n/arb/app_localizations.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/portfolio_controller.dart';
import 'package:meu_curriculo_flutter/presentation/pages/home_page.dart';

class MockPortfolioRepository extends Mock implements IPortfolioRepository {}

void main() {
  late MockPortfolioRepository mockRepository;
  late PortfolioController controller;

  setUp(() {
    mockRepository = MockPortfolioRepository();
    controller = PortfolioController(mockRepository);

    // Default stubs
    when(() => mockRepository.getProjects()).thenAnswer((_) async => []);
    when(() => mockRepository.getExperiences()).thenAnswer((_) async => []);
    when(() => mockRepository.getSkills()).thenAnswer((_) async => []);
    when(() => mockRepository.getCertificates()).thenAnswer((_) async => []);
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PortfolioController>.value(value: controller),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('pt')],
        home: HomePage(),
      ),
    );
  }

  testWidgets('HomePage loads data on startup', (final WidgetTester tester) async {
    // Set a large screen size to avoid overflows in desktop layout
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(createWidgetUnderTest());

    // Verify that loadAllData was called (it's called in addPostFrameCallback)
    // We need to pump to allow the callback to execute
    await tester.pump();

    verify(() => mockRepository.getProjects()).called(1);
    verify(() => mockRepository.getExperiences()).called(1);
    verify(() => mockRepository.getSkills()).called(1);
    verify(() => mockRepository.getCertificates()).called(1);

    await tester.pump(const Duration(seconds: 6));
  });

  testWidgets('HomePage shows error message when loading fails', (
    final WidgetTester tester,
  ) async {
    // Set a large screen size to avoid overflows in desktop layout
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Arrange
    when(
      () => mockRepository.getProjects(),
    ).thenThrow(Exception('Erro de teste'));

    // Act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Run addPostFrameCallback
    await tester.pump(); // Rebuild with error (notifyListeners)

    // Assert
    expect(
      find.text('Falha ao carregar dados. Verifique sua conexão.'),
      findsOneWidget,
    );
    expect(find.text('Tentar novamente'), findsOneWidget);

    await tester.pump(const Duration(seconds: 6));
  });
}

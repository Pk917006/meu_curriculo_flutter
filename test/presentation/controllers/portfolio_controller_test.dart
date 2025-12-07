// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:meu_curriculo_flutter/data/models/project_model.dart';
import 'package:meu_curriculo_flutter/data/repositories/portfolio_repository.dart';
import 'package:meu_curriculo_flutter/presentation/controllers/portfolio_controller.dart';

class MockPortfolioRepository extends Mock implements IPortfolioRepository {}

void main() {
  late PortfolioController controller;
  late MockPortfolioRepository mockRepository;

  setUp(() {
    mockRepository = MockPortfolioRepository();
    controller = PortfolioController(mockRepository);
  });

  group('PortfolioController', () {
    test('Initial state should be correct', () {
      expect(controller.projects, isEmpty);
      expect(controller.experiences, isEmpty);
      expect(controller.skills, isEmpty);
      expect(controller.certificates, isEmpty);
      expect(controller.isLoading, true);
      expect(controller.errorMessage, isNull);
      expect(controller.themeMode, ThemeMode.light);
    });

    test('toggleTheme should switch between light and dark', () {
      expect(controller.themeMode, ThemeMode.light);

      controller.toggleTheme();
      expect(controller.themeMode, ThemeMode.dark);

      controller.toggleTheme();
      expect(controller.themeMode, ThemeMode.light);
    });

    test(
      'loadAllData success should populate lists and set isLoading to false',
      () async {
        // Arrange
        final projects = [
          const ProjectModel(
            id: 1,
            title: 'Test Project',
            description: 'Desc',
            techStack: [],
            imageUrl: '',
            repoUrl: '',
          ),
        ];
        when(
          () => mockRepository.getProjects(),
        ).thenAnswer((_) async => projects);
        when(() => mockRepository.getExperiences()).thenAnswer((_) async => []);
        when(() => mockRepository.getSkills()).thenAnswer((_) async => []);
        when(
          () => mockRepository.getCertificates(),
        ).thenAnswer((_) async => []);

        // Act
        await controller.loadAllData();

        // Assert
        expect(controller.isLoading, false);
        expect(controller.errorMessage, isNull);
        expect(controller.projects, equals(projects));
        verify(() => mockRepository.getProjects()).called(1);
      },
    );

    test(
      'loadAllData failure should set errorMessage and set isLoading to false',
      () async {
        // Arrange
        when(
          () => mockRepository.getProjects(),
        ).thenThrow(Exception('Error loading projects'));
        when(() => mockRepository.getExperiences()).thenAnswer((_) async => []);
        when(() => mockRepository.getSkills()).thenAnswer((_) async => []);
        when(
          () => mockRepository.getCertificates(),
        ).thenAnswer((_) async => []);

        // Act
        await controller.loadAllData();

        // Assert
        expect(controller.isLoading, false);
        expect(controller.errorMessage, isNotNull);
      },
    );
  });
}

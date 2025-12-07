// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Franklyn Roberto - Portfolio';

  @override
  String get errorMessage => 'Failed to load data. Check your connection.';

  @override
  String get adminModeDetected => '🕵️ Admin Mode Detected!';

  @override
  String get retry => 'Retry';
}

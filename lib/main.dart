import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trovemart_app/app/app.dart';
import 'package:trovemart_app/core/storage/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage before running the app.
  await LocalStorage.init();

  // Load environment configuration (.env) before running the app.
  // Production secrets must never be embedded in the Flutter application.
  await dotenv.load(fileName: '.env');

  runApp(
    const ProviderScope(
      child: TrovemartApp(),
    ),
  );
}

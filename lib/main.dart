import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gotas da Felicidade',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('pt'), // Portuguese
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('zh'), // Chinese
        Locale('ja'), // Japanese
        Locale('ar'), // Arabic
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).welcome,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context).dailyMotivation),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).happinessQuote,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text(AppLocalizations.of(context).getMotivation),
            ),
          ],
        ),
      ),
    );
  }
}
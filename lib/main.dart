import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'config/environment.dart';
import 'l10n/app_localizations.dart';
import 'screens/home/home_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuração e validação do ambiente
  if (Environment.isDebug) {
    print(EnvironmentUtils.formatEnvironmentInfo());
  }

  try {
    // Validar configurações essenciais (não quebra o app se falhar)
    EnvironmentValidator.validateGeminiConfig();
  } catch (e) {
    print('⚠️ Aviso de configuração: $e');
    print('📝 O app continuará com mensagens locais');
  }

  // Inicializar Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        // Outros providers podem ser adicionados aqui
      ],
      child: MaterialApp(
        title: Environment.appName,
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
          fontFamily: 'NotoSans',
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark().copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(), // Temporariamente direto para Home
        debugShowCheckedModeBanner: Environment.isDebug,
      ),
    );
  }
}
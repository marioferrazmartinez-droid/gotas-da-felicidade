import 'package:flutter/material.dart';
import 'package:gotas_da_felicidade/l10n/app_localizations.dart';
import 'package:gotas_da_felicidade/widgets/message_card.dart';
import 'package:gotas_da_felicidade/widgets/settings_dialog.dart';
import 'package:gotas_da_felicidade/models/user_model.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  final UserModel user;
  final VoidCallback onLogout;

  const HomeScreen({
    super.key,
    required this.onLanguageChanged,
    required this.user,
    required this.onLogout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentMessage = '';
  bool _isLoading = true;
  String _currentLanguage = 'pt';
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadDailyMessage();
  }

  Future<void> _loadDailyMessage() async {
    setState(() => _isLoading = true);

    // Simular carregamento de mensagem
    await Future.delayed(const Duration(seconds: 2));

    final messages = [
      'Seja a mudança que você quer ver no mundo! 🌟',
      'Cada dia é uma nova oportunidade! 💫',
      'Seu sorriso pode iluminar o dia de alguém! 😊',
      'Pequenos passos levam a grandes conquistas! 🚀',
      'Você é capaz de coisas incríveis! 🌈'
    ];

    setState(() {
      _currentMessage = messages[_counter % messages.length];
      _isLoading = false;
      _counter++;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      // Usando a variável currentCount
      final currentCount = _counter;
      print('Contador atualizado: $currentCount');
      _loadDailyMessage(); // Recarregar mensagem quando o contador mudar
    });
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
    });
    widget.onLanguageChanged(Locale(languageCode));
    _loadDailyMessage();
  }

  void _shareMessage() {
    // Implementar compartilhamento
    print('Compartilhar mensagem: $_currentMessage');
    // Aqui você pode integrar com share_plus
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.appTitle ?? 'Gotas da Felicidade'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _currentMessage.isNotEmpty ? _shareMessage : null,
            tooltip: 'Compartilhar mensagem',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => SettingsDialog(
                currentLanguage: _currentLanguage,
                onLanguageChanged: _changeLanguage,
                user: widget.user,
                onLogout: widget.onLogout,
              ),
            ),
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Informações do usuário
              if (widget.user.photoURL != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.photoURL!),
                  radius: 30,
                ),
              const SizedBox(height: 16),
              Text(
                'Olá, ${widget.user.displayName}!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                widget.user.email,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Mensagem do dia
              Text(
                localizations?.dailyMessage ?? 'Sua Motivação Diária',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 40),

              // Card da mensagem
              MessageCard(
                message: _currentMessage,
                isLoading: _isLoading,
                onTap: _loadDailyMessage,
              ),
              const SizedBox(height: 20),

              // Instrução
              Text(
                localizations?.tapForMore ?? 'Toque para outra mensagem',
                style: Theme.of(context).textTheme.bodySmall,
              ),

              // Contador (para demonstração)
              const SizedBox(height: 40),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Estatística:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mensagens visualizadas: $_counter',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _incrementCounter,
                        child: const Text('Incrementar Contador'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
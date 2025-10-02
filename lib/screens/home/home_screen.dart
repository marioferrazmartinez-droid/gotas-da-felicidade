import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quote_provider.dart';
import '../../widgets/message_card.dart';
import '../../widgets/settings_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentQuoteIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Inicialização geral do app
    // Notificações podem ser adicionadas posteriormente
  }

  void _showNextQuote() {
    setState(() {
      final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
      _currentQuoteIndex = (_currentQuoteIndex + 1) % quoteProvider.quotes.length;
    });
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    );
  }

  void _shareQuote(Quote quote) {
    final shareText = '"${quote.text}" - ${quote.author}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Compartilhando: $shareText')),
    );
  }

  void _showFavorites() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade de favoritos em desenvolvimento')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quoteProvider = Provider.of<QuoteProvider>(context);
    final quotes = quoteProvider.quotes;

    if (quotes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gotas da Felicidade'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _showSettings,
            ),
          ],
        ),
        body: const Center(
          child: Text('Nenhuma mensagem disponível'),
        ),
      );
    }

    final currentQuote = quotes[_currentQuoteIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gotas da Felicidade'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _showFavorites,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MessageCard(
              quote: currentQuote,
              onFavorite: () {
                quoteProvider.toggleFavorite(currentQuote);
              },
              onShare: () => _shareQuote(currentQuote),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _showNextQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Próxima Mensagem'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Toque para mais inspiração',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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

  void _shareQuote(Quote quote) async {
    final shareText = '"${quote.text}" - ${quote.author}\n\nCompartilhado via Gotas da Felicidade';

    // Para WhatsApp
    final whatsappUrl = "whatsapp://send?text=${Uri.encodeComponent(shareText)}";

    // Para outros apps
    final smsUrl = "sms:?body=${Uri.encodeComponent(shareText)}";

    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 200,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Compartilhar via:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.green),
              title: const Text('WhatsApp'),
              onTap: () async {
                Navigator.pop(context);
                if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                  await launchUrl(Uri.parse(whatsappUrl));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('WhatsApp não instalado')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Mensagem de Texto'),
              onTap: () async {
                Navigator.pop(context);
                if (await canLaunchUrl(Uri.parse(smsUrl))) {
                  await launchUrl(Uri.parse(smsUrl));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copiar Texto'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Texto copiado!')),
                );
              },
            ),
          ],
        ),
      ),
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
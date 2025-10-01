import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../../services/ai_service.dart';
import '../../services/auth_service.dart';
import '../../l10n/app_localizations.dart';
import '../../config/environment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _motivationMessage = '';
  bool _isLoading = false;
  bool _hasError = false;
  int _messageCount = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialMotivation();
  }

  Future<void> _loadInitialMotivation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _getMotivation();
  }

  Future<void> _getMotivation() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final message = await AIService.getMotivationalMessage();

      setState(() {
        _motivationMessage = message;
        _isLoading = false;
        _messageCount++;
        _hasError = false;
      });
    } catch (e) {
      if (Environment.isDebug) {
        debugPrint('Erro ao carregar motivação: $e');
      }

      setState(() {
        _isLoading = false;
        _hasError = true;
        _motivationMessage = AppLocalizations.of(context).happinessQuote;
      });
    }
  }

  Future<void> _getTimeBasedMotivation() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final message = await AIService.getTimeBasedMotivation();

      setState(() {
        _motivationMessage = message;
        _isLoading = false;
        _messageCount++;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _motivationMessage = AppLocalizations.of(context).happinessQuote;
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return AppLocalizations.of(context).goodMorning;
    } else if (hour >= 12 && hour < 18) {
      return AppLocalizations.of(context).goodAfternoon;
    } else {
      return AppLocalizations.of(context).goodEvening;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appTitle),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // Temporariamente comentado até implementar auth
          /*
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
            tooltip: AppLocalizations.of(context).logout,
          ),
          */
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getMotivation,
            tooltip: AppLocalizations.of(context).newMotivation,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Saudação
            Text(
              _getGreeting(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 8),

            // Título
            Text(
              AppLocalizations.of(context).dailyMotivation,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),

            // Card da mensagem motivacional
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildMessageContent(),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Botões de ação
            _buildActionButtons(),

            // Informações de debug (apenas em desenvolvimento)
            if (Environment.isDebug) _buildDebugInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    if (_isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).motivationLoading,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (_hasError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.orange.shade600,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            '⚠️ ${AppLocalizations.of(context).error}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.orange.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).happinessQuote,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_objects_outlined,
            color: Colors.blue.shade600,
            size: 48,
          ),
          const SizedBox(height: 20),
          Text(
            _motivationMessage.isNotEmpty
                ? _motivationMessage
                : AppLocalizations.of(context).happinessQuote,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          if (_messageCount > 0) ...[
            const SizedBox(height: 20),
            Text(
              '✨ ${AppLocalizations.of(context).todayMessage}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: _getMotivation,
          icon: const Icon(Icons.auto_awesome),
          label: Text(AppLocalizations.of(context).getMotivation),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        OutlinedButton.icon(
          onPressed: _getTimeBasedMotivation,
          icon: const Icon(Icons.access_time),
          label: Text(AppLocalizations.of(context).newMotivation),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDebugInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          const Divider(),
          Text(
            '🔧 Debug Info',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          Text(
            'Mensagens geradas: $_messageCount',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          Text(
            'API Configurada: ${Environment.geminiApiKey.isNotEmpty}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}